library(shiny)

# Define the overall UI
shinyUI(
  # Use a fluid Bootstrap layout
  fluidPage(     
    # Give the page a title
    titlePanel("Enter Product"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      # Define the sidebar with one input
      sidebarPanel(
        textInput("product", "Product text"),
        hr(),
        helpText("Enter the text that Pogo should analyze."),
        submitButton("Update View")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        h4("Product Stem"),
        verbatimTextOutput("summary"),
        # Show Word Cloud
        h4("Twitter Word Cloud"),
        plotOutput("plot"), 
        h4("Twitter Histogram"),
        plotOutput("twitterHistogram"), 
        h4("BestBuy Boxplot"),
        plotOutput("BestBuyboxplot"),
        h4("NYT sentiment histogram"),
        plotOutput("NYT_histogram")
      )     
    )
  )
)