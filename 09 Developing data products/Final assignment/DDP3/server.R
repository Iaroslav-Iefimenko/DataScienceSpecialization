library(shiny)
library(dplyr)
library(plotly)

tds <- read.csv("https://pkgstore.datahub.io/core/global-temp/monthly_csv/data/329e553af20ec84034a29372c0dce362/monthly_csv.csv", sep=",", header=TRUE, na.strings = c("NA","",'#DIV/0!'))
tdsGCAG <- filter(tds, Source == "GCAG")

month <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
colors <- colors()

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$distPlot <- renderPlotly({
    # Get parameters from input
    minYear <- input$year[1]
    maxYear <- input$year[2]
    mode <- input$mode
    yearString <- toString(minYear)
  
    # intialize data frame
    tdsY <- filter(tdsGCAG, substr(Date, 1, 4) == yearString)
    tdsY <- tdsY[order(tdsY$Date),]
    data <- data.frame(month, yearString = tdsY$Mean)
    colnames(data)[colnames(data)=="yearString"] <- yearString
  
    # add rows to data frame for other years
    for(i in (minYear+1):maxYear) {
      yearString <- toString(i)
      tdsY <- filter(tdsGCAG, substr(Date, 1, 4) == yearString)
      tdsY <- tdsY[order(tdsY$Date),]
      data[yearString] <- tdsY$Mean
    }
  
    # The default order will be alphabetized unless specified as below:
    data$month <- factor(data$month, levels = data[["month"]]);
  
    # plot   
    yearString <- toString(minYear)
    plot <- plot_ly(data = data, x = ~month, y=data[[yearString]], name = yearString, 
                    line = list(color = colors[sample(2:657, 1)]),
                    type = 'scatter', mode = mode)  %>%
      layout(title = 'Monthly mean temperature anomalies',
             yaxis = list(title = 'Monthly anomalies'),
             xaxis = list(title = 'Month'));
  
    # add traces
    for(name in colnames(data)) {
      if (name != yearString && name != 'month') {
        inx <- sample(2:657, 1);
        plot <- add_trace(plot, y = data[[name]], name = name, line = list(color = colors[inx]));
      }
    }
  
    plot
  })
})
