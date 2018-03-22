# load data to variables
setwd("D:/Solutions/Data Science/Capstone")
# twitter data set
con <- file("./final/en_US/en_US.twitter.txt", "r") 
sizeTwitter <- file.size("./final/en_US/en_US.twitter.txt")
linesTwitter <- readLines(con)
lengthTwitter <- length(linesTwitter)
close(con)

# news data set
con <- file("./final/en_US/en_US.news.txt", "r") 
sizeNews <- file.size("./final/en_US/en_US.news.txt")
linesNews <- readLines(con)
lengthNews <- length(linesNews)
close(con)

# blogs data set
con <- file("./final/en_US/en_US.blogs.txt", "r") 
sizeBlogs <- file.size("./final/en_US/en_US.blogs.txt")
linesBlogs <- readLines(con)
lengthBlogs <- length(linesBlogs)
close(con)

# longest elements
twitterMaxLine <- max(nchar(linesTwitter))
newsMaxLine <- max(nchar(linesNews))
blogsMaxLine <- max(nchar(linesBlogs))

# love/hate
loveCount <- length(grep('love', linesTwitter))
hateCount <- length(grep('hate', linesTwitter))
lhRes <- loveCount / hateCount

# biostats tweet
biostatsTwitIndex <- grep("biostats", linesTwitter)
biostatsTwit <- linesTwitter[biostatsTwitIndex]

#sentence count
sentenceCount <- length(grep('A computer once beat me at chess, but it was no match for me at kickboxing', linesTwitter))