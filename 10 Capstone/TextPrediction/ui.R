library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Data Science Capstone by Iaroslav Iefimenko"),
  
  sidebarLayout(
    sidebarPanel(
      # Text input
      textInput("text", label = ('Enter your word/phrase:'), value = ''),
      
      # Number of words slider input
      sliderInput('slider',
                  'No. of Predictions:',
                  min = 1,  max = 50,  value = 10)
      ),
    
      # Show a table of the predicted ngrams
      mainPanel(
        tabsetPanel(
        
          tabPanel('Predicted n-grams in detail',
                   conditionalPanel(condition = "input.text != ''", dataTableOutput('table')),
                   conditionalPanel(condition = "input.text == ''", p('Input some text for prediction.'))),
        
        tabPanel('Useful information',
                 wellPanel(
                   # Description
                   p('This Shiny App predicts the next word based on the text you typed.'),
                   p('Please, use the sidebar fields for prediction:'),
                   tags$ul(
                     tags$li(tags$b('Enter your word/phrase:'), 'Text entered for prediction.'),
                     tags$li(tags$b('No. of Predictions'), 'Number of n-grams that the algorithm will predict.')
                   ),
                   # Link to presentation
                   helpText(a('Program Presentation',
                              href='http://rpubs.com/Iaroslav/363784', 
                              target = '_blank')
                   ),
                   # Link to git repository
                   helpText(a('Code repository',
                              href='https://github.com/Iaroslav-Iefimenko/data-science-capstone',
                              target = '_blank'))
                 )
        )
        )
      )
    )
  )
)
