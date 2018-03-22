library(shiny)
library(plotly)

shinyUI(fluidPage(
  
  titlePanel("Global Temperature Time Series"),
  
  sidebarLayout(
    sidebarPanel(
       sliderInput("year",
                   "Select years range for plot:",
                   sep = '',
                   min = 2000,
                   max = 2016,
                   value = c(2006, 2010)),
       selectInput("mode",
                   "Select mode of series:",
                   choices = c('markers+lines', 'lines'),
                   selected = 'markers+lines',
                   multiple = FALSE)
    ),
    
    mainPanel(
      mainPanel(
        div(
          h4("Use the two controls on the left pane to select:"), 
          h5("   1. the range of years for plotted data"),
          h5("   2. the type of plot lines"),
          h5("The chart adjusts automatically to reflect the effect of parameters changing."),
          h5("" , a("ui.R & server.R code in Yaroslav Iefimenko' Github Repository", 
                    href="https://github.com/Iaroslav-Iefimenko/DDP3Final")),
          h5("" , a("Presentation with detail information", 
                    href="http://rpubs.com/Iaroslav/353062"))),
        div(
          plotlyOutput("distPlot", width = '700px')
        )
    )
  )
)))
