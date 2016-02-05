library(datasets)
data(swiss)


swissData <- swiss
# Fertility, Agriculture, Examination, Education, Catholic, Infant.Mortality
recordsNum<-nrow(swissData)


shinyServer(
  function(input, output) {
    # Compute the forumla text in a reactive expression since it is 
    # shared by the output$caption and output$mpgPlot expressions
    formulaText <- reactive({
      a<-paste("Infant.Mortality ~ ", input$variable)
      
      if (input$variable2 != "None"){
        a<-paste(a," + ")
        a<-paste(a,input$variable2)
      }
      a
    })

    
    # Return the formula text for printing as a caption
    output$caption <- renderText({
      formulaText()
    })
    
    # Generate a plot of the requested variable against mpg and only 
    # include outliers if requested
    output$deathPlot <- renderPlot({
      swissData <- head(swiss,input$recordsNum)
      boxplot(as.formula(formulaText()), 
              data = swissData)
    
    })
    
    output$densPlot <- renderPlot({
      
      swissData <- head(swiss,input$recordsNum)
      if (input$variable2 != "None"){
        par(mfrow=c(1,2))
        title<-paste("Density of",input$variable2)
        plot(density(swissData[input$variable2][,]),main=title)        
      }
      title<-paste("Density of",input$variable)
      plot(density(swissData[input$variable][,]),main=title)
    })
    
    
    output$comparePlot <- renderPlot({
      swissData <- head(swiss,input$recordsNum)
      fit<-lm(formulaText(),data = swissData)
      
      plot(swissData$Infant.Mortality,swissData[input$variable][,],main=input$variable)
      lines(swissData$Infant.Mortality,fit$fitted, col="red")
      
    })
    
   
    output$regPlot <- renderPlot({
      swissData <- head(swiss,input$recordsNum)
      fit<-lm(formulaText(),data = swissData)
      
      par(mfrow=c(2,2))
      plot(fit,main=formulaText())
      output$funtionLm <- renderText({
        formulaText()
      })
      
    })
    
    
    
  }
)
