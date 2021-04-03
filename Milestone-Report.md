---
title: "Milestone-Report"
author: "Yigang"
output:
  html_document:
    keep_md: yes
  pdf_document: default
---

## Introduction

The goal of this project is just to display that you've gotten used to working with the data and that you are on track to create your prediction algorithm. Please submit a report on R Pubs (http://rpubs.com/) that explains your exploratory analysis and your goals for the eventual app and algorithm. This document should be concise and explain only the major features of the data you have identified and briefly summarize your plans for creating the prediction algorithm and Shiny app in a way that would be understandable to a non-data scientist manager. You should make use of tables and plots to illustrate important summaries of the data set. The motivation for this project is to: 

1. Demonstrate that you've downloaded the data and have successfully loaded it in.
2. Create a basic report of summary statistics about the data sets.
3. Report any interesting findings that you amassed so far.
4. Get feedback on your plans for creating a prediction algorithm and Shiny app.  



## Load Libraries


```r
library(ggplot2)
library(ggpubr)
library(NLP)
library(tm)
library(stringi)
library(dplyr)
library(RColorBrewer)
library(wordcloud)
library(SnowballC)
library(RWeka)
library(RWekajars)
library(rJava)
library(conflicted)
```

## Load Data Set

### About the Corpora

The corpora are collected from publicly available sources by a web crawler. The crawler checks for language, so as to mainly get texts consisting of the desired language*.

### Dataset download link:

https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip


```r
blogs <- readLines("final/en_US/en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
news <- readLines("final/en_US/en_US.news.txt", encoding = "UTF-8", skipNul = TRUE)
twitter <- readLines("final/en_US/en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE)
```

## An Overview of Data


```r
# Get file sizes
blogs.size <- file.info("final/en_US/en_US.blogs.txt")$size / 1024 ^ 2
news.size <- file.info("final/en_US/en_US.news.txt")$size / 1024 ^ 2
twitter.size <- file.info("final/en_US/en_US.twitter.txt")$size / 1024 ^ 2

# Get number of words and number of lines in files
data.frame("filename" = c("blogs", "news", "twitter"),
           "filesize.MB" = c(blogs.size, news.size, twitter.size),
           "num.lines" = c(length(blogs), length(news),length(twitter)),
           "num.words" = c(sum(stri_count_words(blogs)), 
                           sum(stri_count_words(news)), sum(stri_count_words(twitter))))
```

```
##   filename filesize.MB num.lines num.words
## 1    blogs    200.4242    899288  37546239
## 2     news    196.2775     77259   2674536
## 3  twitter    159.3641   2360148  30093413
```

## Preprocessing

#### Important - limited sample size

Since our work will eventually be applied to a shinyapp, and it will be deploied to the free server provided by Rstuido, which is not an very powerful one, so we have to sacrifice some accuracy to get better computing time. 
We just focus on the English text and the data from twitter and take a small sample size to analyse.


```r
set.seed(1234)
twsample <- sample(twitter, length(twitter)*0.05 ) #take sample
```

### Filtering punctuations, numbers and etc.


```r
twcorpus <- VCorpus(VectorSource(twsample)) %>% # convert to vector
        tm_map(., PlainTextDocument) %>% # create a plain text document
        tm_map(., content_transformer(tolower)) %>% # transform to lower case
        tm_map(., removePunctuation) %>% # remove punctuation
        tm_map(., removeNumbers)%>% # remove numbers
        tm_map(., stripWhitespace) %>% # remove extra white space
        tm_map(., function(x)iconv(x, "latin1", "ASCII", sub=""))%>% # remove non-ASCII
        tm_map(., stemDocument) # apply Porter's stemming algorithm
```

### Save corpus file and convert to data frame 


```r
saveRDS(twcorpus, file = "twcorpus.RData")
twcorpusx <- readRDS("twcorpus.RData")
twcorpusx <- data.frame(text = get("content", twcorpusx), stringsAsFactors = FALSE)
```

## Exploratory Analysis

### Word Cloud

A colorful word cloud is always a straightforward way to observe the corpus.


```r
# make word cloud
wordcloud(twsample, max.words = 100, random.order = FALSE,
          colors=brewer.pal(8,"Accent"))
```

![](Milestone-Report_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

### Tokenization and N-gram Method

N-gram is a contiguous sequence of n items from a given sample of text or speech.
Here, we will obtain unigrams, nigrams, trigrams and quadgrams.
Since the code of processing n-gram method with different n taken are similaer, and it is tedious to show a bunch of repeated code, so here we just show the code for getting unigram and the code for integrating plots.


```r
unigram <- NGramTokenizer(twcorpusx, Weka_control(min = 1, max = 1))
unigram <- data.frame(table(unigram))
unigram <- unigram[order(unigram$Freq,decreasing = TRUE),]

uni<- ggplot(unigram[1:10,], aes(x=reorder(unigram, Freq), y=Freq,  fill = Freq))+
        scale_fill_gradient(low = "#56B1F7", high = "#132B43",)+
        geom_bar(stat = "identity")+ 
        coord_flip()+
        xlab("Unigram") + ylab("Frequency") 
```







Integrate four n-gram plots


```r
ggarrange(uni, bi, tri, qua, ncol = 2, nrow = 2)
```

![](Milestone-Report_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

## Conclusion and Next Steps

1. We can see some trends from the word cloud and our bar plot, but if we have a given word and we want to predict the next word people may use, we still need more work to do.
2. We are modeling our data with machine learning methods.
3. Build and deploy a interactive shiny app for users, which can do the word predication.
4. Make slides for presentation to introduction the our shiny app.




