library(shiny)
library(png)
# Define UI for app that draws a histogram ----
ui <- shinyUI(
    navbarPage("Text Trend of Twitter",
        tabPanel("Predictor",
                 HTML("<strong>Author:Yigang</strong>"),
            sidebarLayout(
                sidebarPanel(
                    h5("About this application"),        
                    helpText("This application takes your inputed words
                             and predict the next word and the most likely used terms."),
                    br(),
                    h5("About the corpus"),
                    helpText("Meanwhile, you will see freqence of the five most common
                             used terms from our sample, which contains over
                             one hundred thousand sentences collected from Twitter."),
                    br(),
                    h5("How to use"),
                    helpText("You can input a single word, a two-word term or a three-word term .
                             For your reference, check out Word cloud panel generated from our sample."),
                    br(),
                    h5("Notice before enter"),
                    helpText("Please only leave the whitespace between the words in each term"),
                    textInput("inputwords", "Enter a term you are interested in",value = ""),
                    helpText("Once you finished click on the below button, or
                             you can just press Enter key!"),
                    submitButton('Go!')
                    ),
                mainPanel(
                    h4("Text Trend Plot"),
                    helpText("Blow is a bar plot. The y-axis is the top five popular terms in our 
                             database, and the x-axis is the frequence in the database which contains 
                             over one hundred thousand sentences collected from Twitter"),            
                    plotOutput("plot"),
                    h4("Most Common Usage"),
                    helpText("Duo the then limited sample size, we can only provide prediction
                             for terms less than four words. Also, our database only contains
                             common used terms. Feel feel to check out the Word cloud panel
                             to get some idea!"),
                    verbatimTextOutput('pred')
                    )
                )
                                  
            ),
        tabPanel("Word Cloud",
                 mainPanel(
                         plotOutput("png", height = 800, width = 800)
                 )
        )
                         
)
)