# pogo
MIT Hackathon project correlating social media discussion with consumer behavior.

# Overview
Pogo is a simple project to explore the relationship between consumer sentiment about products, as expressed in the natural language text of product reviews, Twitter feeds and NYTimes articles with the explicit product ratings on Best Buy.  This is a team project for the MIT Hackathon at the Hack/Reduce space in Cambridge, MA in March 2015.  

Subgoals were to play with the APIs  available by the sponsors (Indico.io, Knowledgent, Basis, Tamr), tap interesting public datasets, and integregate diverse tools of interest to the team, including R, Shiny and Python and make these work together.

# Data sources

* **[Indico.io](https://indico.io/)** for sentiment analysis of natural language text
* **[Best Buy API]()** for product search, consumer ratings (numeric) and reviews (text)
* **[NYTimes API](http://developer.nytimes.com/)** for news articles mentioning specific products
* **[Twitter API](https://dev.twitter.com/rest/public)** for Twitter feeds

# Tools / platforms
* Languages:   [R](),  [Python]()
* [R Studio](http://www.rstudio.com/)
* [Shiny](http://shiny.rstudio.com/) application server for R

# Methodology

For a specific product search term, e.g. "iPhone" Pogo:
* Searches the Best Buy products API to find all products matching the search term
* Extracts list of matching SKUs 
* Retrieves product ratings and customer review text verbatims from the Best Buy Reviews API for those SKUs
* Calculates the sentiment value of the review text using Indico.io
* Searches Twitter Developer API for Tweets matching the search term, and calculates sentiment
* Searches NYTimes Articles API for news articles matching the search term

# Results
Below is a screen image of one Pogo visualizations, showing the mean sentiment score of the text comments written by customers (e.g. "The  is everything that was promised to Apple customers. I suggest this phone to upgraders and everyone else!"), versus the numerical product rating on Best Buy (e.g. "5" stars).   This graph shows a strong correlation between the numerical rating and the sentiment score of the review text, spanning the entire 0.0 to 1.0 scale. Of course, you'd expect more positive words with more positive reviews, the striking thing was how well the sentiment API scores reflected our intuitive sense of the sentiments when reading the words:
<a href="http://tinypic.com?ref=2889zl" target="_blank"><img src="http://i61.tinypic.com/2889zl.png" border="0" width="80%" alt="Image and video hosting by TinyPic" ></a>


For each product, Pogo also produces World Clouds of the text in the Best Buy product reviews and NY Times articles:
<a href="http://tinypic.com?ref=6yf8z5" target="_blank"><img src="http://i59.tinypic.com/6yf8z5.png" border="0" width="70%" alt="Image and video hosting by TinyPic"></a>

Twitter sentiment is displayed as a histogam of sentiment value vs word frequency. This graph below shows that for PlayStation,  tweets referencing #playstation were most commonly  skewed toward the positive sentiment, although there is a wide distribution of sentiment for individual tweets.
<a href="http://tinypic.com?ref=260y52e" target="_blank"><img src="http://i62.tinypic.com/260y52e.png" border="0" width="70%" alt="Image and video hosting by TinyPic"></a>

# Findings
* The Indico.io API for sentiment analysis was very easy to work with with, and yielded scores which jibe with both
# Challenges
* The Best Buy Products API has relatively coarse search capabilities.  For instance, a search for `iPhone` will return a list of products, many of which are actually iPhones specifically, but also includes things like iPhone cases and iPhone speakers. The alternative is an exact text search, which requires incredible precision from user input. 

```json
  { "sku": 1722009, "name": "Apple - iPhone 5c 16GB Cell Phone - Pink (AT&T)" },
  { "sku": 1724671, "name": "Apple - iPhone 5c 16GB Cell Phone - Pink (Sprint)",
  { "sku": 6704115, "name": "ADOPTED - Cushion Wrap Case for Apple® iPhone® 5 and 5s - Black/Rose Gold" },
```
* The Best Buy, Twitter and NYTimes APIs have relatively stringent rate limits, both in terms of queries per second as well as total queries over longer periods, including 15 minutes, hour or day.  During the development process, test queries can inadvertently lock out the API for a period of time.

* Shiny and Python integrate well on local development machines, but require advanced configuration such as buildbacks when deploying to cloud based servers.


# Installation and setup

* Clone the repo, `git clone https://github.com/pietersv/pogo`
* Sign up for Developer access at the following sites 
* Create a file called `secret` in the `/pogo` directory with these entries:
```
BEST_BUY_API_APPLICATION=pogo 
BEST_BUY_API_KEY=
NYTIMES_ARTICLE_API_KEY=
NYTIMES_BOOKREVIEWS_API_KEY=
TWITTER_API_KEY=
TWITTER_API_SECRET=
TWITTER_ACCESS_TOKEN=
TWITTER_ACCESS_SECRET=
```
* Launch R Studio and in the console:
  - define a variable in R `secretLoc <- "Users/you/projects/pogo/secret"~/`
  - define a variable with the directory `shinyLoc <- "Users/you/projects/pogo"`
  - start the Shiny server `runApp(shinyLoc, launch.browser=TRUE)` (to deploy set `host=0.0.0.0, port=80`)
  - replace various stray hard coded paths, grep for /Users




