library(shiny)
library(png)

path=getwd()
source(paste(path,"/Processing.R", sep = ""))

server <- function(input, output) {
    output$pred <- renderPrint({
        nwpred(input$inputwords)

    })
    output$plot <- renderPlot({
        predplot(input$inputwords)
       
    })
    output$png <- renderPlot({
        
        pic = readPNG(paste(path,"/wc.png", sep = ""))
        plot.new()
        grid::grid.raster(pic)
        
    })
}




