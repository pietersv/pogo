library(shiny)
library(tm)
library(wordcloud)
library(memoise)
library(twitteR)
library(SnowballC)
library(indicoio)
library(jsonlite)


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


# generates a bestbuy boxplot from user query 
BestBuy_boxplot<-function(query) {
  ## Read secret keys from a local file 
  myProp <- read.table(secretLoc,header=FALSE, sep="=", row.names=1, strip.white=TRUE, na.strings="NA", stringsAsFactors=FALSE)
  BEST_BUY_API_KEY <- myProp["BEST_BUY_API_KEY",1]
  BEST_BUY_API_APPLICATION <- myProp["BEST_BUY_API_APPLICATION",1]
  
  ## Query Best Buy API for products that match a specified query string
  #query <- "iPhone"
  url_products <- paste(
    "http://api.remix.bestbuy.com/v1/products",
    "(longDescription=",query,"*)",
    "?show=","sku,name",
    "&pageSize=","10",
    "&page=","1",
    "&format=","json",
    "&apiKey=",BEST_BUY_API_KEY,
    sep="") 
  
  products <- jsonlite::fromJSON(url_products)   
  
  #products$products$sku
  
  url_reviews <- paste(
    "http://api.remix.bestbuy.com/v1/reviews(sku%20in(",
    paste((products$products$sku), collapse=","),
    "))",
    "?format=json",
    "&apiKey=",BEST_BUY_API_KEY,
    "&show=id,sku,rating,comment,title",
    "&pageSize=","100",
    "&page=","1",
    sep="")
  
  reviews <- jsonlite::fromJSON(url_reviews)
  
  print (length(names(reviews)))
  
  nReviews <- nrow(reviews$reviews)
  reviews$reviews$sentiment <- NA
  #sentiments <- rep(NA, nReviews)
  for(i in 1:nReviews) {
    reviews$reviews$sentiment[i] <- sentiment(reviews$reviews$comment[i])
  }
  
  #aggregate(reviews$reviews$sentiment, by=list(reviews$reviews$rating), FUN=mean)[2]
  boxplot(sentiment ~ rating, data= reviews$reviews, xlab = "rating", ylab = "sentiment", main="BestBuy's Common Sentiment vs Product Ratings")
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
  
  output$twitterHistogram <- renderPlot({
    plot_histogram(get_twitter(input$product))
  })
 
  output$BestBuyboxplot <- renderPlot({
    BestBuy_boxplot(input$product)
  })
})

# pull tweeter data

# turn it into a freq plot

# turn it into timeseries plot
?data()
