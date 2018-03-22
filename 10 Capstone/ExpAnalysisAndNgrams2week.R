#load library
library(stringi)
library(tm) # for text mining
library(RWeka)
library(SnowballC)
library(plotly)
# load data to variables
#set path varables
rootDir <- "D:/Solutions/Data Science/Capstone"
blogsPath <- file.path(rootDir, "final/en_US/en_US.blogs.txt")
newsPath <- file.path(rootDir, "final/en_US/en_US.news.txt")
profanitiesPath <- file.path(rootDir, "swearWords.txt")
# twitter data set
twitterPath <- file.path(rootDir, "final/en_US/en_US.twitter.txt")
con <- file(twitterPath, "r") 
linesTwitter <- readLines(con, skipNul = TRUE)
close(con)

# news data set
con <- file(newsPath, "r") 
linesNews <- readLines(con, skipNul = TRUE)
close(con)

# blogs data set
con <- file(blogsPath, "r") 
linesBlogs <- readLines(con, skipNul = TRUE)
close(con)

# profanities
con <- file(profanitiesPath, "r") 
profanities <- readLines(con, skipNul = TRUE)
close(con)

#Exploratory analysis---------------------------------
# Get words count in files by rows
blogsWordsCount <- stri_count_words(linesBlogs)
newsWordsCount <- stri_count_words(linesNews)
twitterWordsCount <- stri_count_words(linesTwitter)

# Get total words count in files
blogsWordsTotalCount <- sum(blogsWordsCount)
newsWordsTotalCount <- sum(newsWordsCount)
twitterWordsTotalCount <- sum(twitterWordsCount)

# Get words mean count in files
blogsWordsMean <- mean(blogsWordsCount)
newsWordsMean <- mean(newsWordsCount)
twitterWordsMean <- mean(twitterWordsCount)

# ngrams creation-----------------------------------
# Sample the data
set.seed(4321)
smpl <- c(sample(linesBlogs, length(linesBlogs) * 0.0015),
          sample(linesNews, length(linesNews) * 0.0015),
          sample(linesTwitter, length(linesTwitter) * 0.0015))

# Load the data as a corpus
smpl <- sapply(smpl,function(row) iconv(row, "latin1", "ASCII", sub=""))
corp <- VCorpus(VectorSource(smpl))

# clear data
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))

corp <- tm_map(corp, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+") # remove URLs
corp <- tm_map(corp, toSpace, "@[^\\s]+") # remove twitter handles
corp <- tm_map(corp, toSpace, "/")
corp <- tm_map(corp, toSpace, "@")
corp <- tm_map(corp, toSpace, "\\|")
corp <- tm_map(corp, tolower)
corp <- tm_map(corp, PlainTextDocument)
corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, removeNumbers)
corp <- tm_map(corp, stripWhitespace)
corp <- tm_map(corp, removeWords, profanities)
#corp <- tm_map(corp, removeWords, stopwords("english"))
#corp <- tm_map(corp, stemDocument)

# prepare frequency calculation
getFrequency <- function(dm) {
  m <- as.matrix(dm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  return (d)
}
bigram <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
trigram <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
quadgram <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
pentagram <- function(x) NGramTokenizer(x, Weka_control(min = 5, max = 5))
hexagram <- function(x) NGramTokenizer(x, Weka_control(min = 6, max = 6))

# calculate frequency
f1w <- getFrequency(removeSparseTerms(TermDocumentMatrix(corp), 0.99))
save(f1w, file="freq.w1.RData")

f2w <- getFrequency(TermDocumentMatrix(corp, control = list(tokenize = bigram)))
save(f2w, file="freq.w2.RData")

f3w <- getFrequency(TermDocumentMatrix(corp, control = list(tokenize = trigram)))
save(f3w, file="freq.w3.RData")

f4w <- getFrequency(TermDocumentMatrix(corp, control = list(tokenize = quadgram)))
save(f4w, file="freq.w4.RData")

f5w <- getFrequency(TermDocumentMatrix(corp, control = list(tokenize = pentagram)))
save(f5w, file="freq.w5.RData")

f6w <- getFrequency(TermDocumentMatrix(corp, control = list(tokenize = hexagram)))
save(f6w, file="freq.w6.RData")

frequencyInfo <- list("f1" = f1w, "f2" = f2w, "f3" = f3w, "f4" = f4w, "f5" = f5w, "f6" = f6w)
save(frequencyInfo, file="freq.info.RData")
