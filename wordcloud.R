library(twitteR)
library(wordcloud)
library(tm)
library(SnowballC)

api_key <- "GO2w8H7fsU6prfRIc6vG49aec"

api_secret <- "PLB969zdMsPll3lzUpBG8UIC6a99JXrSqxUP8fWJ8lUgjvzThV"

access_token <- "3091565165-1LOxNVORx75ZnfgyZNUdq7OIzsHzo8OLZ8QaP5q"

access_token_secret <- "iOlmQoEJti1I5KiFH9MGDCt5mnJrClzEsEBZSdCcMPpvs"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

r_stats <- searchTwitter("#iphone" && "watch", n=1500, lang="en")

r_stats_text <- sapply(r_stats, function(x) x$getText())
#create corpus
r_stats_text_corpus <- Corpus(VectorSource(r_stats_text))

#clean up
r_stats_text_corpus <- tm_map(r_stats_text_corpus, stripWhitespace, lazy=TRUE)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, content_transformer(tolower), lazy=TRUE)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, removePunctuation, lazy=TRUE)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, function(x)removeWords(x,stopwords()), lazy=TRUE)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, stemDocument, lazy=TRUE)

setwd("D:/new")

wordcloud(r_stats_text_corpus, max.words=50)

