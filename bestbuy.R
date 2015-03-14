
library(indicoio)
library(jsonlite)

## Read secret keys from a local file 
myProp <- read.table(secretLoc,header=FALSE, sep="=", row.names=1, strip.white=TRUE, na.strings="NA", stringsAsFactors=FALSE)
BEST_BUY_API_KEY <- myProp["BEST_BUY_API_KEY",1]
BEST_BUY_API_APPLICATION <- myProp["BEST_BUY_API_APPLICATION",1]

## Query Best Buy API for products that match a specified query string
query <- "iPhone"
url_products <- paste(
  "http://api.remix.bestbuy.com/v1/products",
  "(longDescription=",query,"*)",
  "?show=","sku,name",
  "&pageSize=","10",
  "&page=","1",
  "&format=","json",
  "&apiKey=",BEST_BUY_API_KEY,
  sep="") 

products <- jsonlite::fromJSON(url_products)   

#products$products$sku

url_reviews <- paste(
  "http://api.remix.bestbuy.com/v1/reviews(sku%20in(",
  paste((products$products$sku), collapse=","),
  "))",
  "?format=json",
  "&apiKey=",BEST_BUY_API_KEY,
  "&show=id,sku,rating,comment,title",
  "&pageSize=","100",
  "&page=","1",
  sep="")

reviews <- jsonlite::fromJSON(url_reviews)

print (length(names(reviews)))

nReviews <- nrow(reviews$reviews)
reviews$reviews$sentiment <- NA
#sentiments <- rep(NA, nReviews)
for(i in 1:nReviews) {
  reviews$reviews$sentiment[i] <- sentiment(reviews$reviews$comment[i])
}

#aggregate(reviews$reviews$sentiment, by=list(reviews$reviews$rating), FUN=mean)[2]
boxplot(sentiment ~ rating, data= reviews$reviews, xlab = "rating", ylab = "sentiment", main="Great state")







