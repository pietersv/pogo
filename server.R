library(shiny)
library(tm)
library(wordcloud)
library(memoise)
library(indicoio)
library(twitteR)
library(SnowballC)
library(indicoio)

get_twitter<-function(input_str) {
  Sys.sleep(0.5)
  ## Read secret keys from a local file
  myProp <- read.table(secretLoc,header=FALSE, sep="=", row.names=1, strip.white=TRUE, na.strings="NA", stringsAsFactors=FALSE)
  TWITTER_API_KEY <- myProp["TWITTER_API_KEY",1]
  TWITTER_API_SECRET <- myProp["TWITTER_API_SECRET",1]
  TWITTER_ACCESS_TOKEN <- myProp["TWITTER_ACCESS_TOKEN",1]
  TWITTER_ACCESS_SECRET <- myProp["TWITTER_ACCESS_SECRET",1]
  
  ## Authenticate with Twitter
  setup_twitter_oauth(TWITTER_API_KEY,TWITTER_API_SECRET,TWITTER_ACCESS_TOKEN,TWITTER_ACCESS_SECRET)
  
  ## Search Twitter
  r_stats <- searchTwitter(input_str, n=100, lang="en")
  return(r_stats)
}

# 

# define a function to display wordcloud
display_wordcloud<-function(get_twitter) {
  r_stats_text <- sapply(get_twitter, function(x) x$getText())
  r_stats_text_corpus <- Corpus(VectorSource(r_stats_text))
  tdm <- TermDocumentMatrix(r_stats_text_corpus)
  m <- as.matrix(tdm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  
  #filter common words
  skipWords <- c("and", "the", "for", "are", "but", "or", "nor", "yet", "so",
                 "if", "a", "an", "from", "want", "how")
  inds <- 1:200
  inds <- which(!(inds %in% which(d$word %in% skipWords)))
  #filter usernames
  inds <- inds[which(!(inds %in% grep("@", d$word)))]
  
  ## Display Wordcloud
  wordcloud(d[inds, "word"], d[inds,"freq"])
  
}


# define a function that takes r_stats and outputs 
# a histogram with the mean highlighted 
plot_histogram<-function(r_stats) {
  # generate a vector of sentiment scores
  emotionVec <- rep(NA, length(r_stats))
  for (i in 1:length(r_stats)) {
    emotionVec[i] <- sentiment(r_stats[[i]]$text)
  }
  #plot the histogram
  hist(emotionVec, breaks='FD',main = paste("Mean Twitter Sentiment is ", mean(emotionVec), sep=""))
  abline(v=mean(emotionVec),col='red',lwd=3)
  abline(v=mean(emotionVec)+sd(emotionVec),col='green',pch=2)
  abline(v=mean(emotionVec)-sd(emotionVec),col='green')
  
}


# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$selection)
      })
    })
  })
  
  output$summary <- renderPrint({
    paste("Input stem is: ", input$product, sep = " ")
  })
  
  output$plot <- renderPlot({
    #temporary word cloud
    #data(crude)
    #crude <- tm_map(crude, removePunctuation)
    #crude <- tm_map(crude, function(x)removeWords(x,stopwords()))
    #wordcloud(crude)
    display_wordcloud(get_twitter(input$product))
  })
  
  # Fill in the spot we created for a plot
  output$twitterFreqPlot <- renderPlot({
    plot(1:10, 10:1, 
         main = "Twitter mentions over time",
         xlab = "time", ylab = "mentions")
    
  })
  output$twitterHistogram <- renderPlot({
    plot_histogram(get_twitter(input$product))
  })
 
})

# pull tweeter data

# turn it into a freq plot

# turn it into timeseries plot
?data()
