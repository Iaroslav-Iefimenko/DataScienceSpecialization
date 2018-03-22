library(stringi)
library(tm) # for text mining
library(quanteda) # for text mining

setwd("D:/Solutions/Data Science/Capstone")

# n-grams
load(file="freq.w1.RData")
load(file="freq.w2.RData")  
load(file="freq.w3.RData")  
load(file="freq.w4.RData")  
load(file="freq.w5.RData")  
load(file="freq.w6.RData")  

# profanities
con <- file("swearWords.txt", "r") 
# profanities <- VectorSource(readLines(con, skipNul = TRUE))
profanities <- readLines(con, skipNul = TRUE)
close(con)

getLastNwords <- function(text, n) {
  cnt <- stri_count_words(text)
  if (cnt <= n) {
    return (text)
  }
  
  words <- stri_extract_all_words(text)
  words <- tail(words[[1]], n)
  if (n == 1) {
    return (words)
  }
    
  res <- stri_join_list(as.list(words), sep = " ", collapse = " ")
  return(res)
}

addNgramsToRes <- function(fw, res, ctext, n) {
  # search in n-grams
  r <- fw[stri_startswith_fixed(fw$word, ctext), ]
  if (nrow(r) > 0) {
    r <- head(r, n)
    res <- rbind(res, r)
  }
  
  return(res)
}

clearText <- function(inputText) {
  # clear data
  text <- iconv(inputText, "latin1", "ASCII", sub="")
  toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
  corp <- VCorpus(VectorSource(text))
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
  
  #get cleared text
  # df <- data.frame(text=unlist(sapply(corp, `[`, "content")), stringsAsFactors=F)
  # ctext <- df[1,]
  ctext <- corp[[1]]$content
  return(ctext)
}

clearTextQ <- function(inputText) {
  words <- tolower(
    quanteda::tokens(inputText,
                     remove_numbers = T,
                     remove_punct = T,
                     remove_symbols = T,
                     remove_separators = T,
                     remove_twitter = T,
                     remove_hyphens = T,
                     remove_url = T,
                     ngrams = 1,
                     concatenator = " "))
  text <- paste(words, collapse = " ")
  return (text)
}

predictWord <- function(inputText, numOfGrams) {
  #get cleared text
  ctext <- clearTextQ(inputText)
  res <- data.frame(word = factor(), freq = numeric())
  
  # hexagrams
  ctext <- getLastNwords(ctext, 5)
  if (stri_count_words(ctext) == 5) {
    res <- addNgramsToRes(f6w, res, ctext, numOfGrams)
    if (nrow(res) == numOfGrams) {
      return (res)
    }
  }
  
  # pentagrams
  ctext <- getLastNwords(ctext, 4)
  if (stri_count_words(ctext) == 4) {
    res <- addNgramsToRes(f5w, res, ctext, numOfGrams - nrow(res))
    if (nrow(res) == numOfGrams) {
      return (res)
    }
  }
  
  # quadgrams
  ctext <- getLastNwords(ctext, 3)
  if (stri_count_words(ctext) == 3) {
    res <- addNgramsToRes(f4w, res, ctext, numOfGrams - nrow(res))
    if (nrow(res) == numOfGrams) {
      return (res)
    }
  }
  
  # trigrams
  ctext <- getLastNwords(ctext, 2)
  if (stri_count_words(ctext) == 2) {
    res <- addNgramsToRes(f3w, res, ctext, numOfGrams - nrow(res))
    if (nrow(res) == numOfGrams) {
      return (res)
    }
  }
  
  # bigrams
  ctext <- getLastNwords(ctext, 1)
  if (stri_count_words(ctext) == 1) {
    res <- addNgramsToRes(f2w, res, ctext, numOfGrams - nrow(res))
    if (nrow(res) == numOfGrams) {
      return (res)
    }
  }
  
  # single words
  r <- head(f1w, numOfGrams - nrow(res))
  res <- rbind(res, r)
  
  return (res)
}