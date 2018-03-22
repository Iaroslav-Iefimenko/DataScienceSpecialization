---
title: "CodeBook"
author: "Iaroslav Iefimenko"
date: "18.01.2016"
output: html_document
---

#run_analysis.R
This is a main file of Getting and Cleaning Data Course Project. It contains the R source code for execution of following actions:

* Download data file (URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip')
* Unzip data from data file.
* Create Results folder.
* Load features from features file.
* Load test data set:
+ Load test subject.
+ Load test X data.
+ Load test Y data.
+ Create test data table.
* Load train data set:
+ Load train subject.
+ Load train X data.
+ Load train Y data.
+ Create train data table.
* Execute required actions
+ Merges the training and the test sets to create one data set.
+ Extracts only the measurements on the mean and standard deviation for each measurement.
+ Uses descriptive activity names to name the activities in the data set.
+ Appropriately labels the data set with descriptive variable names.
+ creates a tidy data set with the average of each variable for each activity and each subject.

#meanStdData.csv (ResultsData folder)
This file contains the measurements on the mean and standard deviation for each measurement.
* id
* activity
* tBodyAcc.std...X
* tBodyAcc.std...Y
* tBodyAcc.std...Z
* tGravityAcc.std...X
* tGravityAcc.std...Y
* tGravityAcc.std...Z
* tBodyAccJerk.std...X
* tBodyAccJerk.std...Y
* tBodyAccJerk.std...Z
* tBodyGyro.std...X
* tBodyGyro.std...Y
* tBodyGyro.std...Z
* tBodyGyroJerk.std...X
* tBodyGyroJerk.std...Y
* tBodyGyroJerk.std...Z
* tBodyAccMag.std..
* tGravityAccMag.std..
* tBodyAccJerkMag.std..
* tBodyGyroMag.std..
* tBodyGyroJerkMag.std..
* fBodyAcc.std...X
* fBodyAcc.std...Y
* fBodyAcc.std...Z
* fBodyAccJerk.std...X
* fBodyAccJerk.std...Y
* fBodyAccJerk.std...Z
* fBodyGyro.std...X
* fBodyGyro.std...Y
* fBodyGyro.std...Z
* fBodyAccMag.std..
* fBodyBodyAccJerkMag.std..
* fBodyBodyGyroMag.std..
* fBodyBodyGyroJerkMag.std..
* tBodyAcc.mean...X
* tBodyAcc.mean...Y
* tBodyAcc.mean...Z
* tGravityAcc.mean...X
* tGravityAcc.mean...Y
* tGravityAcc.mean...Z
* tBodyAccJerk.mean...X
* tBodyAccJerk.mean...Y
* tBodyAccJerk.mean...Z
* tBodyGyro.mean...X
* tBodyGyro.mean...Y
* tBodyGyro.mean...Z
* tBodyGyroJerk. 

#tidyData.csv and tidyData.txt (ResultsData folder)
These files contain an independent tidy data set with the average of each variable for each activity and each subject.
* id 
* activity 
* tBodyAcc.std...X_mean 
* tBodyAcc.std...Y_mean 
* tBodyAcc.std...Z_mean 
* tGravityAcc.std...X_mean 
* tGravityAcc.std...Y_mean 
* tGravityAcc.std...Z_mean 
* tBodyAccJerk.std...X_mean 
* tBodyAccJerk.std...Y_mean 
* tBodyAccJerk.std...Z_mean 
* tBodyGyro.std...X_mean 
* tBodyGyro.std...Y_mean 
* tBodyGyro.std...Z_mean 
* tBodyGyroJerk.std...X_mean 
* tBodyGyroJerk.std...Y_mean 
* tBodyGyroJerk.std...Z_mean 
* tBodyAccMag.std.._mean 
* tGravityAccMag.std.._mean 
* tBodyAccJerkMag.std.._mean 
* tBodyGyroMag.std.._mean 
* tBodyGyroJerkMag.std.._mean 
* fBodyAcc.std...X_mean 
* fBodyAcc.std...Y_mean 
* fBodyAcc.std...Z_mean 
* fBodyAccJerk.std...X_mean 
* fBodyAccJerk.std...Y_mean 
* fBodyAccJerk.std...Z_mean 
* fBodyGyro.std...X_mean 
* fBodyGyro.std...Y_mean 
* fBodyGyro.std...Z_mean 
* fBodyAccMag.std.._mean 
* fBodyBodyAccJerkMag.std.._mean 
* fBodyBodyGyroMag.std.._mean 
* fBodyBodyGyroJerkMag.std.._mean 
* tBodyAcc.mean...X_mean 
* tBodyAcc.mean...Y_mean 
* tBodyAcc.mean...Z_mean 
* tGravityAcc.mean...X_mean 
* tGravityAcc.mean...Y_mean 
* tGravityAcc.mean...Z_mean 
* tBodyAccJerk.mean...X_mean 
* tBodyAccJerk.mean...Y_mean 
* tBodyAccJerk.mean...Z_mean 
* tBodyGyro.mean...X_mean 
* tBodyGyro.mean...Y_mean 
* tBodyGyro.mean...Z_mean 
* tBodyGyroJerk.mean...X_mean 
* tBodyGyroJerk.mean...Y_mean 
* tBodyGyroJerk.mean...Z_mean 
* tBodyAccMag.mean.._mean 
* tGravityAccMag.mean.._mean 
* tBodyAccJerkMag.mean.._mean 
* tBodyGyroMag.mean.._mean 
* tBodyGyroJerkMag.mean.._mean 
* fBodyAcc.mean...X_mean 
* fBodyAcc.mean...Y_mean 
* fBodyAcc.mean...Z_mean 
* fBodyAcc.meanFreq...X_mean 
* fBodyAcc.meanFreq...Y_mean 
* fBodyAcc.meanFreq...Z_mean 
* fBodyAccJerk.mean...X_mean 
* fBodyAccJerk.mean...Y_mean 
* fBodyAccJerk.mean...Z_mean 
* fBodyAccJerk.meanFreq...X_mean 
* fBodyAccJerk.meanFreq...Y_mean 
* fBodyAccJerk.meanFreq...Z_mean 
* fBodyGyro.mean...X_mean 
* fBodyGyro.mean...Y_mean 
* fBodyGyro.mean...Z_mean 
* fBodyGyro.meanFreq...X_mean 
* fBodyGyro.meanFreq...Y_mean 
* fBodyGyro.meanFreq...Z_mean 
* fBodyAccMag.mean.._mean 
* fBodyAccMag.meanFreq.._mean 
* fBodyBodyAccJerkMag.mean.._mean 
* fBodyBodyAccJerkMag.meanFreq.._mean 
* fBodyBodyGyroMag.mean.._mean 
* fBodyBodyGyroMag.meanFreq.._mean 
* fBodyBodyGyroJerkMag.mean.._mean 
* fBodyBodyGyroJerkMag.meanFreq.._mean