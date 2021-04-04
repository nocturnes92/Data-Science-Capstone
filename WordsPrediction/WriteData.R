library(NLP)
library(tm)
library(dplyr)
library(RWeka)
library(stringr)
library(tidyverse)
library(ggplot2)
library(wordcloud)

# Read data


path = getwd()
twitter <- readLines(paste(path,'/en_US.twitter.txt', sep = ""), 
                     encoding = "UTF-8", skipNul = TRUE)

# Take sample
set.seed(1234)
twsample <- sample(twitter, length(twitter)*0.05 ) #take sample

#Clean data
twcorpus <- VCorpus(VectorSource(twsample)) %>% # convert to vector
        tm_map(., PlainTextDocument) %>% # create a plain text document
        tm_map(., content_transformer(tolower)) %>% # transform to lower case
        tm_map(., removePunctuation) %>% # remove punctuation
        tm_map(., removeNumbers)%>% # remove numbers
        tm_map(., stripWhitespace) %>% # remove extra white space
        tm_map(., function(x)iconv(x, "latin1", "ASCII", sub=""))%>% # remove non-ASCII
        tm_map(., stemDocument) # apply Porter's stemming algorithm

# Save data
saveRDS(twcorpus, file = "twcorpus.RData")
twcorpusx <- readRDS(paste(path,"/twcorpus.RData",sep = ""))
twcorpusx <- data.frame(text = get("content", twcorpusx), stringsAsFactors = FALSE)

# Modeling and write data
# n=2
bigram <- NGramTokenizer(twcorpusx, Weka_control(min = 2, max = 2))
bigram <- data.frame(table(bigram))
bidata <- bigram[order(bigram$Freq,decreasing = TRUE),]

bidata$prop <- bidata$Freq/sum(bidata$Freq)
bidata <- bidata[bidata$Freq>9, ]
bidata$prop <- bidata$Freq/sum(bidata$Freq)

saveRDS(bidata, "bidata.RData")

# n=3
trigram <- NGramTokenizer(twcorpusx, Weka_control(min = 3, max = 3))
trigram <- data.frame(table(trigram))
tridata <- trigram[order(trigram$Freq,decreasing = TRUE),]

tridata$prop <- tridata$Freq/sum(tridata$Freq)
tridata <- tridata[tridata$Freq>4, ]
tridata$prop <- tridata$Freq/sum(tridata$Freq)

saveRDS(tridata, "tridata.RData")

# n=4
quadgram  <- NGramTokenizer(twcorpusx, Weka_control(min = 4, max = 4))
quadgram  <- data.frame(table(quadgram ))
quaddata  <- quadgram [order(quadgram $Freq,decreasing = TRUE),]

quaddata$prop <- quaddata$Freq/sum(quaddata$Freq)
quaddata <- quaddata[quaddata$Freq>4, ]
quaddata$prop <- quaddata$Freq/sum(quaddata$Freq)

saveRDS(quaddata, "quaddata.RData")

# Word cloud
png(file="wc.png")
wordcloud(twsample, max.words = 100, random.order = FALSE,
          colors=brewer.pal(8,"Accent"))
dev.off()







