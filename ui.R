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
        helpText("Enter the text that Pogo should analyze.")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        h4("Product Stem"),
        verbatimTextOutput("summary"),
        # Show Word Cloud
        plotOutput("plot"), 
        plotOutput("twitterFreqPlot")  
      )     
    )
  )
)