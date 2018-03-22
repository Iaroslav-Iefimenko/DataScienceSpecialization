#File run_Analysis.R contains the source code for downloading and cleaning 
#the collected from the accelerometers from the Samsung Galaxy S smartphone.
 
# Author: Iaroslav Iefimenko

#IMPORTANT!! File is created in Windows OS

#Set working directory
setwd("D:/Data science/Getting and Cleaning Data Course Project")

#check data file existence and download data for analysis------------------------------------------
library(httr) 

urlLink <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "data.zip"

if(!file.exists(fileName)){
  print("Start download data file")
  download.file(urlLink, fileName)
  print("Data file is downloaded")
} else {
  print("Data file is downloaded before this run of run_analysis.R")
}

#unzip data from data file
print("Unzip data from data file.")
unzip(fileName)
print("Data file is unzipped.")
dataF <- "UCI HAR Dataset"

#check results data folder existence and create it
resultsF <- "ResultsData"
if(!dir.exists(resultsF)){
  print("Create results folder")
  dir.create(resultsF)
  print("Results folder is created")
} else {
  print("Results folder is created before this run of run_analysis.R")
}

#load data from files into R-----------------------------------------------------------------------
#load features from features file
print("load features from features file.")
featuresFN <- file.path(dataF, "features.txt", fsep = "/")
features <- read.table(featuresFN, sep="", stringsAsFactors=FALSE)
print("features are loaded.")

#------------------------

#load test data and create test data table
print("load test subject.")
subjectTestFN <- file.path(dataF, "test/subject_test.txt", fsep = "/")
subjectTest <- read.table(subjectTestFN, sep="", stringsAsFactors=FALSE, col.names = "id")

print("load test X data.")
xTestFN <- file.path(dataF, "test/X_test.txt", fsep = "/")
xTest <- read.table(xTestFN, sep="", stringsAsFactors=FALSE, col.names = features$V2)

print("load test Y data.")
yTestFN <- file.path(dataF, "test/y_test.txt", fsep = "/")
yTest <- read.table(yTestFN, sep="", stringsAsFactors=FALSE, col.names = "activity")

print("create test data table.")
testData <- cbind(subjectTest,yTest,xTest)
print("test data table is created.")

#------------------------

#load train data and create train data table
print("load train subject.")
subjectTrainFN <- file.path(dataF, "train/subject_train.txt", fsep = "/")
subjectTrain <- read.table(subjectTrainFN, sep="", stringsAsFactors=FALSE, col.names = "id")

print("load train X data.")
xTrainFN <- file.path(dataF, "train/X_train.txt", fsep = "/")
xTrain <- read.table(xTrainFN, sep="", stringsAsFactors=FALSE, col.names = features$V2)

print("load train Y data.")
yTrainFN <- file.path(dataF, "train/y_train.txt", fsep = "/")
yTrain <- read.table(yTrainFN, sep="", stringsAsFactors=FALSE, col.names = "activity")

print("create train data table.")
trainData <- cbind(subjectTrain,yTrain,xTrain)
print("train data table is created.")

#1. Merges the training and the test sets to create one data set.----------------------------------
print("1. Merges the training and the test sets to create one data set.")
library(plyr)
data <- rbind(testData, trainData)
data <- arrange(data, id)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.--------
print("2. Extracts only the measurements on the mean and standard deviation for each measurement.")
meanStdData <- data[,c(1,2,grep("std", colnames(data)), grep("mean", colnames(data)))]
meanStdDataFN <- file.path(resultsF, "meanStdData.csv")
write.csv(meanStdData, meanStdDataFN)

#3. Uses descriptive activity names to name the activities in the data set.------------------------
print("3. Uses descriptive activity names to name the activities in the data set.")
activityLabelsFN <- file.path(dataF, "activity_labels.txt", fsep = "/")
activityLabels <- read.table(activityLabelsFN, sep="", stringsAsFactors=FALSE)

#4. Appropriately labels the data set with descriptive variable names.-----------------------------
print("4. Appropriately labels the data set with descriptive variable names.")
data$activity <- factor(data$activity, levels=activityLabels$V1, labels=activityLabels$V2)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
print("5. creates a tidy data set with the average of each variable for each activity and each subject.")
tidyData <- ddply(meanStdData, .(id, activity), .fun=function(x){ colMeans(x[,-c(1:2)]) })
colnames(tidyData)[-c(1:2)] <- paste(colnames(tidyData)[-c(1:2)], "_mean", sep="")

tidyDataFN <- file.path(resultsF, "tidyData.csv")
write.csv(tidyData, tidyDataFN)

tidyDataFN2 <- file.path(resultsF, "tidyData.txt")
write.table(tidyData, tidyDataFN2, row.names = FALSE)

print("Done.")