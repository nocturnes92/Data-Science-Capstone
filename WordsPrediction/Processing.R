library(NLP)
library(tm)
library(dplyr)
library(RWeka)
library(stringr)
library(tidyverse)
library(dplyr)
library(ggplot2)

# For saving loading time, preparation work are written in PrepFunc.R
# soure PrepFunc.R is needed for first time run

#path=getwd()
#path=paste(path,"/WriteData.R",sep = "")
#source(path)

# Read data
path = getwd()
bidata <- readRDS(paste(path,"/bidata.RData",sep = ""))
tridata <- readRDS(paste(path,"/tridata.RData",sep = ""))
quaddata <- readRDS(paste(path,"/quaddata.RData",sep = ""))

# Pred function
nwpred <- function(input){
        
        input <- data_frame(text = input)
        replace <- "[^[:alpha:][:space:]]*"
        input <- input %>%
                mutate(text = str_replace_all(text, replace, ""))
        nums <- str_count(input, boundary("word"))
        input <- tolower(input)
        
        p <-if(nums == 0){
                print = "Enter your desired words in sidebar panel!"}
        
        else if(nums == 1){
                print=bipred(input)}
        
        else if(nums == 2) {
                print=tripred(input)}
        
        else if(nums == 3) {
                print=quadpred(input)}
        
        if (nums > 3){
                p ="We cannot provide prediction for longer terms."}
        
        return(p)
}

# Pred plot
predplot <- function(input){
        
        input <- data_frame(text = input)
        replace <- "[^[:alpha:][:space:]]*"
        input <- input %>%
                mutate(text = str_replace_all(text, replace, ""))
        nums <- str_count(input, boundary("word"))
        input <- tolower(input)
        
        t <- if(nums == 1){
                input <- paste("^", input, " ", sep = "")
                bioutput <- head(bidata[grep(input, bidata[,1]), ], 5)%>%
                        data.frame()
                ggplot(bioutput, aes(x=reorder(bigram, Freq), y=Freq, fill = Freq)) +
                        scale_fill_gradient(low = "#56B1F7", high = "#132B43",)+
                        geom_bar(stat = "identity")+ 
                        coord_flip()+
                        xlab("Two-word terms") + ylab("Frequency")}
        else if(nums == 2) {
                input <- paste("^", input, sep = "")
                trioutput <- head(tridata[grep(input, tridata[,1]), ], 5)%>%
                        data.frame()
                ggplot(trioutput, aes(x=reorder(trigram, Freq), y=Freq, fill = Freq)) +
                        scale_fill_gradient(low = "#56B1F7", high = "#132B43",)+
                        geom_bar(stat = "identity")+ 
                        coord_flip()+
                        xlab("Three-word terms") + ylab("Frequency") 
        }
        else if(nums == 3) {
                input <- paste("^", input, sep = "")
                quadoutput <- head(quaddata[grep(input, quaddata[,1]), ], 5)%>%
                        data.frame()
                ggplot(quadoutput, aes(x=reorder(quadgram , Freq), y=Freq, fill = Freq)) +
                        scale_fill_gradient(low = "#56B1F7", high = "#132B43",)+
                        geom_bar(stat = "identity")+ 
                        coord_flip()+
                        xlab("Four-word terms") + ylab("Frequency") }
        
        return(t)
}

# sub function n=2
bipred <- function(input){
        input <- paste("^", input, " ", sep = "")
        bioutput <- head(bidata[grep(input, bidata[,1]), ], 5)%>%
                data.frame()
        biprint <- as.matrix(bioutput[1,1])
        biprint <- strsplit(trimws(as.character(biprint)), "\\s")%>%
                data.frame()
        biprint <- biprint[2, ]
        
        if(is.na(biprint)){
                biprint = "not found."
        }
        
        biprint=paste("The next word most likely to be used is:", biprint)
        
        return(biprint)
}

# sub function n=3
tripred <- function(input){
        input <- paste("^", input, sep = "")
        trioutput <- head(tridata[grep(input, tridata[,1]), ], 5)%>%
                data.frame()
        triprint <- as.matrix(trioutput[1,1])
        triprint <- strsplit(trimws(as.character(triprint)), "\\s")%>%
                data.frame()
        triprint <- triprint[3, ]
        
        if(is.na(triprint)){
                triprint = "not found."
        }
        
        triprint=paste("The next word most likely to be used is:", triprint)
        
        return(triprint)
}

# sub function n=4
quadpred <- function(input){
        input <- paste("^", input, sep = "")
        quadoutput <- head(quaddata[grep(input, quaddata[,1]), ], 5)%>%
                data.frame()
        quadprint <- as.matrix(quadoutput[1,1])
        quadprint <- strsplit(trimws(as.character(quadprint)), "\\s")%>%
                data.frame()
        quadprint <- quadprint[4, ]
        
        if(is.na(quadprint)){
                quadprint = "not found."
        }
        
        quadprint=paste("The next word most likely to be used is:", quadprint)
        
        return(quadprint)
}

