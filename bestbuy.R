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

url_products

products <- fromJSON(url_products)   
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

reviews <- fromJSON(url_reviews)

