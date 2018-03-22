#load library
library(stringi)
library(dplyr)
library(quanteda)
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

# Sample the data
set.seed(4321)
smpl <- c(sample(linesBlogs, length(linesBlogs) * 0.005),
          sample(linesNews, length(linesNews) * 0.005),
          sample(linesTwitter, length(linesTwitter) * 0.005))

# Load the data as a corpus
smpl <- sapply(smpl,function(row) iconv(row, "latin1", "ASCII", sub=""))
corp <- corpus(unlist(smpl))

# Tokenize  function
tokenizeQ = function(x, ngramSize) {
  
  f <- tolower(
    quanteda::tokens(x,
                     remove_numbers = T,
                     remove_punct = T,
                     remove_symbols = T,
                     remove_separators = T,
                     remove_twitter = T,
                     remove_hyphens = T,
                     remove_url = T,
                     ngrams = ngramSize,
                     concatenator = " "))
  # f <- tokens_remove(f, profanities)
  m <- dfm(f, ngrams = ngramSize, concatenator = " ")
  r <- textstat_frequency(m)
  res <- r[,c('feature', 'frequency')]
  colnames(res) <- c('word', 'freq')
  return (res)
}

f1w <- tokenizeQ(corp, 1)
f2w <- tokenizeQ(corp, 2)
f3w <- tokenizeQ(corp, 3)
f4w <- tokenizeQ(corp, 4)
f5w <- tokenizeQ(corp, 5)
f6w <- tokenizeQ(corp, 6)

save(f1w, file="freq.w1.RData")
save(f2w, file="freq.w2.RData")
save(f3w, file="freq.w3.RData")
save(f4w, file="freq.w4.RData")
save(f5w, file="freq.w5.RData")
save(f6w, file="freq.w6.RData")