library(shiny)
library(tm)
library(wordcloud)
library(memoise)
library(indicoio)

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
    data(crude)
    crude <- tm_map(crude, removePunctuation)
    crude <- tm_map(crude, function(x)removeWords(x,stopwords()))
    wordcloud(crude)
  })
  
  # Fill in the spot we created for a plot
  output$twitterFreqPlot <- renderPlot({
    plot(1:10, 10:1, 
         main = "Twitter mentions over time",
         xlab = "time", ylab = "mentions")
  })
})

?data()
