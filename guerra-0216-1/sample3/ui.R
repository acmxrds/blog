library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Infant.Mortality in Swissland. Regression from dataset"),
  sidebarPanel(
    helpText("This app will help creating a Regression about Infant Mortality in Swissland"),
    helpText("1.- Select the 1st variable in order to create the Regression"),
    helpText("2.- Optionally Select the 2on variable for multivariate Regression"),
    helpText("3.- Select # of records from the Swiss dataset available for the application"),
    selectInput("variable", "Variable 1:",
                list("Fertility" = "Fertility", 
                     "Agriculture" = "Agriculture",
                     "Examination" = "Examination",
                     "Education" = "Education",
                     "Catholic" = "Catholic")),

    selectInput("variable2", "Variable 2:",
                list("None"= "None",
                     "Fertility" = "Fertility", 
                     "Agriculture" = "Agriculture",
                     "Examination" = "Examination",
                     "Education" = "Education",
                     "Catholic" = "Catholic")),
    sliderInput("recordsNum", "Number of records:", 
                min=2, max=nrow(swiss), value=47,step=1)
  ),
  mainPanel(
    h3(textOutput("caption")),
    
    plotOutput("deathPlot"),
    plotOutput("comparePlot"),
    plotOutput("densPlot"),
    h1(textOutput("funtionLm")),
    plotOutput("regPlot")
  )
))
