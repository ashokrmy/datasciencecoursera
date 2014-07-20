

library(shiny)


# Define server logic required to summarize and view the selected
# dataset
shinyServer(function(input, output) {
  
  # The output$summary depends on the datasetInput reactive
  # expression, so will be re-executed whenever datasetInput is
  # invalidated
  # (i.e. whenever the input$dataset changes)
  output$summary <- renderPrint({
    summary(iris)
  })
  
  # The output$view depends on both the databaseInput reactive
  # expression and input$obs, so will be re-executed whenever
  # input$dataset or input$obs is changed. 
  output$view <- renderTable({
    set.seed(62433)
    iris[sample(nrow(iris), size = input$obs),]
  })
  
  # By declaring datasetInput as a reactive expression we ensure 
  # that:
  #
  #  1) It is only called when the inputs it depends on changes
  #  2) The computation and result are shared by all the callers 
  #    (it only executes a single time)
  #
  algorithmInput <- reactive(input$algorithm)
  
  output$results <- renderPrint({
    

    # split in training testing datasets
    trainIndex <- sample(nrow(iris), size = nrow(iris)*input$slidertrainsplit)
    training = iris[trainIndex,]
    testing = iris[-trainIndex,]
    
    # apply selected classification algorithm
    if(algorithmInput()=="rpart") {
      
      # print classification parameters
      print("Algorithm selected: rpart")
      print(paste("Training set: ", input$slidertrainsplit*100, "%", sep = ""))
      print(paste("Testing set: ", (1-input$slidertrainsplit)*100, "%", sep = ""))
      
      # build rpart model
      library(rpart)
      set.seed(62433)
      model <- rpart(Species ~ . , data= iris)
      
      # test rpart model
      pred <- predict(model, testing, type  = "class")
      print(table(predicted = pred, reference = testing$Species))
      
      # print model
      summary(model)
      
    } else if(algorithmInput()=="randomForest") {
      
      # print classification parameters
      print("Algorithm selected: randomForest")
      print(paste("Training set: ", input$slidertrainsplit*100, "%", sep = ""))
      print(paste("Testing set: ", (1-input$slidertrainsplit)*100, "%", sep = ""))
      
      # build randomForest model
      library(randomForest)
      set.seed(62433)
      model <- randomForest(Species ~ . , data= iris)
      
      # test randomForest model
      pred <- predict(model, testing, type  = "class")
      print(table(predicted = pred, reference = testing$Species))
      
      # print model
      summary(model)
      
      
    } else if(algorithmInput()=="lda") {
        
      
      # print classification parameters
      print("Algorithm selected: lda")
      print(paste("Training set: ", input$slidertrainsplit*100, "%", sep = ""))
      print(paste("Testing set: ", (1-input$slidertrainsplit)*100, "%", sep = ""))
      
      # build lda model
      library(MASS)
      set.seed(62433)
      model <- lda(Species ~ . , data= iris)
      
      # test lda model
      pred <- predict(model, testing, type  = "class")
      print(table(predicted = pred$class, reference = testing$Species))
      
      # print model
      summary(model)      
      
    }  else{
      print("Error no Algorithm selected")
    }
    
  }) 

})