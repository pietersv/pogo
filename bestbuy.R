
myProp <- read.table("~/Exp/pogo/secret", header=FALSE, sep="=", row.names=1, strip.white=TRUE, na.strings="NA", stringsAsFactors=FALSE)

BEST_BUY_API_KEY <- myProp["BEST_BUY_API_KEY",1]
BEST_BUY_API_APPLICATION <- myProp["BEST_BUY_API_APPLICATION",1]

url1 <- paste("http://api.remix.bestbuy.com/v1/products(longDescription=iPhone*|sku=7619002)?show=sku,name&pageSize=15&page=5&format=json&apiKey=", BEST_BUY_API_KEY,sep="")
url1
