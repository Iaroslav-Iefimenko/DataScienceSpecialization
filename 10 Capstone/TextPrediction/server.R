library(shiny)
library(stringi)
library(quanteda) # for text mining

# load ngrams datasets
load(url('https://github.com/Iaroslav-Iefimenko/data-science-capstone/raw/master/freq.w1.RData'))
load(url('https://github.com/Iaroslav-Iefimenko/data-science-capstone/raw/master/freq.w2.RData'))
load(url('https://github.com/Iaroslav-Iefimenko/data-science-capstone/raw/master/freq.w3.RData'))
load(url('https://github.com/Iaroslav-Iefimenko/data-science-capstone/raw/master/freq.w4.RData'))
load(url('https://github.com/Iaroslav-Iefimenko/data-science-capstone/raw/master/freq.w5.RData'))
load(url('https://github.com/Iaroslav-Iefimenko/data-science-capstone/raw/master/freq.w6.RData'))

# profanities
con <- url('https://raw.githubusercontent.com/Iaroslav-Iefimenko/data-science-capstone/master/swearWords.txt') 
# profanities <- VectorSource(readLines(con, skipNul = TRUE))
profanities <- readLines(con, skipNul = TRUE)
close(con)

# Define server logic
shinyServer(function(input, output) {
  prediction =  reactive({
    
    # Get input
    inpText = input$text
    nPrediction = input$slider
    
    # Predict
    prediction = predictWord(inpText, nPrediction)
  })

  output$table = renderDataTable(prediction(), 
                                 list(pageLength = 10,
                                      lengthMenu = list(c(5, 10, 50), c('5', '10', '100')),
                                      searching = FALSE
                                 ))
})

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

addFwordCol <- function(res) {
  ngrams <- res[,1]
  fword <- c()
  for (i in 1:nrow(ngrams)) {
    fword[i] <- getLastNwords(ngrams[i], 1)
  }
  res <- cbind(res, fword)
  colnames(res) <- c('N-gram', 'Frequency', 'Next word')
  return(res)
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
      res <- addFwordCol(res)
      return (res)
    }
  }
  
  # pentagrams
  ctext <- getLastNwords(ctext, 4)
  if (stri_count_words(ctext) == 4) {
    res <- addNgramsToRes(f5w, res, ctext, numOfGrams - nrow(res))
    if (nrow(res) == numOfGrams) {
      res <- addFwordCol(res)
      return (res)
    }
  }
  
  # quadgrams
  ctext <- getLastNwords(ctext, 3)
  if (stri_count_words(ctext) == 3) {
    res <- addNgramsToRes(f4w, res, ctext, numOfGrams - nrow(res))
    if (nrow(res) == numOfGrams) {
      res <- addFwordCol(res)
      return (res)
    }
  }
  
  # trigrams
  ctext <- getLastNwords(ctext, 2)
  if (stri_count_words(ctext) == 2) {
    res <- addNgramsToRes(f3w, res, ctext, numOfGrams - nrow(res))
    if (nrow(res) == numOfGrams) {
      res <- addFwordCol(res)
      return (res)
    }
  }
  
  # bigrams
  ctext <- getLastNwords(ctext, 1)
  if (stri_count_words(ctext) == 1) {
    res <- addNgramsToRes(f2w, res, ctext, numOfGrams - nrow(res))
    if (nrow(res) == numOfGrams) {
      res <- addFwordCol(res)
      return (res)
    }
  }
  
  # single words
  r <- head(f1w, numOfGrams - nrow(res))
  res <- rbind(res, r)
  
  res <- addFwordCol(res)
  return (res)
}