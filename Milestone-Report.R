library(shiny)
library(stringr)
library(tidyverse)
library(ggplot2)

bidata <- readRDS('C:/Users/yx/Documents/R/Data-Science-Capstone/bidata.RData')
tridata <- readRDS('C:/Users/yx/Documents/R/Data-Science-Capstone/tridata.RData')
quaddata <- readRDS('C:/Users/yx/Documents/R/Data-Science-Capstone/quaddata.RData')


nwpred <- function(input){
        
        input <- data_frame(text = input)
        replace <- "[^[:alpha:][:space:]]*"
        input <- input %>%
                mutate(text = str_replace_all(text, replace, ""))
        nums <- str_count(input, boundary("word"))
        input <- tolower(input)
        
        p <-if(nums == 0){
                print = "Inter your desired words"}
        
        else if(nums == 1){
                print=paste("Single word given,", bipred(input))}
        
        else if(nums == 2) {
                print=paste("Two words given,", tripred(input))}
        
        else if(nums == 3) {
                print=paste("Three words given,", quadpred(input))}
        
        if (nums > 3){
                p ="We cannot provide prediction for longer terms duo to limited computing power"}
        
        return(p)
}

predplot <- function(input){
        
        input <- data_frame(text = input)
        replace <- "[^[:alpha:][:space:]]*"
        input <- input %>%
                mutate(text = str_replace_all(text, replace, ""))
        nums <- str_count(input, boundary("word"))
        input <- tolower(input)
        
        t <- if(nums == 1){
                input <- paste("^", input, sep = "")
                bioutput <- head(bidata[grep(input, bidata[,1]), ], 5)%>%
                        data.frame()
                ggplot(bioutput, aes(x=reorder(bigram, Freq), y=Freq, fill = Freq)) +
                        scale_fill_gradient(low = "#56B1F7", high = "#132B43",)+
                        geom_bar(stat = "identity")+ 
                        coord_flip()+
                        xlab("Bigram") + ylab("Frequency")}
        else if(nums == 2) {
                input <- paste("^", input, sep = "")
                trioutput <- head(tridata[grep(input, tridata[,1]), ], 5)%>%
                        data.frame()
                ggplot(trioutput, aes(x=reorder(trigram, Freq), y=Freq, fill = Freq)) +
                        scale_fill_gradient(low = "#56B1F7", high = "#132B43",)+
                        geom_bar(stat = "identity")+ 
                        coord_flip()+
                        xlab("Triigram") + ylab("Frequency") 
        }
        else if(nums == 3) {
                input <- paste("^", input, sep = "")
                quadoutput <- head(quaddata[grep(input, quaddata[,1]), ], 5)%>%
                        data.frame()
                ggplot(quadoutput, aes(x=reorder(quadgram , Freq), y=Freq, fill = Freq)) +
                        scale_fill_gradient(low = "#56B1F7", high = "#132B43",)+
                        geom_bar(stat = "identity")+ 
                        coord_flip()+
                        xlab("Quadgram") + ylab("Frequency") }
        
        return(t)
}

bipred <- function(input){
        input <- paste("^", input, sep = "")
        bioutput <- head(bidata[grep(input, bidata[,1]), ], 5)%>%
                data.frame()
        biprint <- as.matrix(bioutput[1,1])
        
        if(is.na(biprint)){
                biprint = "not found duo to limited data size"
        }
        
        biprint=paste("the likely used two-word terms is", biprint)
        
        return(biprint)
}

tripred <- function(input){
        input <- paste("^", input, sep = "")
        trioutput <- head(tridata[grep(input, tridata[,1]), ], 5)%>%
                data.frame()
        triprint <- as.matrix(trioutput[1,1])
        
        if(is.na(triprint)){
                triprint = "not found duo to limited data size"
        }
        
        triprint=paste("the likely used three-word terms is", triprint)
        
        return(triprint)
}

quadpred <- function(input){
        input <- paste("^", input, sep = "")
        quadoutput <- head(quaddata[grep(input, quaddata[,1]), ], 5)%>%
                data.frame()
        quadprint <- as.matrix(quadoutput[1,1])
        
        if(is.na(quadprint)){
                quadprint = "not found duo to limited data size"
        }
        
        quadprint=paste("the likely used four-word terms is", quadprint)
        
        return(quadprint)
}