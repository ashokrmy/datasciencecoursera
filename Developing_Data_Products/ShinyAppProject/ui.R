
# This is the user-interface definition of a Shiny web application.

library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Testing Classification Algorithms on Iris Dataset"),
  
  # Sidebar with controls for the algorithms and output
  sidebarLayout(
    position = "left",
    
    sidebarPanel(
      
      numericInput("obs", "Number of observations to view:", 5), 
         
      sliderInput("slidertrainsplit",
                  "Proportion of Training observations",
                  min = 0, max = 1, value = 0.7, step = 0.1),
      
      selectInput("algorithm", "Choose a Classification algorithm:", 
                  choices = c("rpart", "randomForest", "lda"))
      

    ),

     
    # Show the some example of observations, a summary of the dataset 
    # and the results on the model
    mainPanel(

      p("This App shows the application of 3 different classification algorithms (rpart, randomForest and lda) to the iris dataset."),
      p("First it shows randomly n observations of the iris dataset, where n is the number of observations specified on the sidebar panel (5 by default)."),
      p("Then it shows summary statistics for the iris dataset."),
      p("Lastly it trains a classification algorithm chosen by the user on the sidepar panel, splitting the iris dataset in training and testing sets based on the chosen proportion chosen on the sidebar (by defuault 70% training 30% testing)."),
      
      
      
      h2("Dataset"),
      tableOutput("view"), 
      
      h2("Summary Statistics"),
      verbatimTextOutput("summary"), 
      
      h2("Results"),
      verbatimTextOutput("results")
    )
  )
))