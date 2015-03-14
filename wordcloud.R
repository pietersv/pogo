library(twitteR)
library("wordcloud")
library("tm")
library(SnowballC)

## Read secret keys from a local file
myProp <- read.table(secretLoc,header=FALSE, sep="=", row.names=1, strip.white=TRUE, na.strings="NA", stringsAsFactors=FALSE)
TWITTER_API_KEY <- myProp["TWITTER_API_KEY",1]
TWITTER_API_SECRET <- myProp["TWITTER_API_SECRET",1]
TWITTER_ACCESS_TOKEN <- myProp["TWITTER_ACCESS_TOKEN",1]
TWITTER_ACCESS_SECRET <- myProp["TWITTER_ACCESS_SECRET",1]

## Authenticate with Twitter
setup_twitter_oauth(TWITTER_API_KEY,TWITTER_API_SECRET,TWITTER_ACCESS_TOKEN,TWITTER_ACCESS_SECRET)

## Search Twitter
r_stats <- searchTwitter("#bigdata", n=100, lang="en")

r_stats_text <- sapply(r_stats, function(x) x$getText())
r_stats_text_corpus <- Corpus(VectorSource(r_stats_text))
tdm <- TermDocumentMatrix(r_stats_text_corpus)
m <- as.matrix(tdm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

#filter common words
skipWords <- c("and", "the", "for", "are", "but", "or", "nor", "yet", "so",
               "if", "a", "an", "from", "want", "how")
inds <- 1:200
inds <- which(!(inds %in% which(d$word %in% skipWords)))
#filter usernames
inds <- inds[which(!(inds %in% grep("@", d$word)))]

## Display Wordcloud
wordcloud(d[inds, "word"], d[inds,"freq"])