##
## Script Author: Ralph Waldenmaier
##
## Description (provided by the JHU on coursera):
## The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
## The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers 
## on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data 
## set as described below, 2) a link to a Github repository with your script for performing the analysis, 
## and 3) a code book that describes the variables, the data, and any transformations or work that you 
## performed to clean up the data called CodeBook.md. You should also include a README.md in the repo 
## with your scripts. This repo explains how all of the scripts work and how they are connected.  
## 
## One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
## 
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
## 
## Here are the data for the project: 
## 
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
## 
##  You should create one R script called run_analysis.R that does the following. 
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##

library(dplyr)
library(data.table)
library(reshape2)

#global variables
zippedDataset <- "dataset.zip"

if(!file.exists(zippedDataset))
{
  # download dataset
  zip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(zip, zippedDataset)
  rm(zip)  
}

######################################################################################################
## 1. Merges the training and the test sets to create one data set.
## obtaining feature information
features <- data.table(read.table(unz(zippedDataset, "UCI HAR Dataset/features.txt"), 
                                  col.names=c("id", "feature"), 
                                  stringsAsFactors=FALSE))
                                  
# read data from zipfile
print("reading data")

## test data
# reading measurements
data.test.x <- data.table(read.table(unz(zippedDataset, "UCI HAR Dataset/test/X_test.txt")))
#data.test.x[, id:=1:nrow(data.test.x)] # adding a id to the dataset -> use a function for that operation
#setkey(data.test.x, id) # define a key

## specifying column names
#setnames(data.test.x, c("id", as.character(features$feature)))
setnames(data.test.x, as.character(features$feature))

# reading activities
data.test.y <- data.table(read.table(unz(zippedDataset, "UCI HAR Dataset/test/y_test.txt")))
#data.test.y[, id:=1:nrow(data.test.y)] # adding a id to the dataset -> use a function for that operation
#setkey(data.test.y, id) # define a key
#setnames(data.test.y, c("activity", "id"))
setnames(data.test.y, "activity_id")

#reading subjects
data.test.subject <- data.table(read.table(unz(zippedDataset, "UCI HAR Dataset/test/subject_test.txt")))
#data.test.subject[, id:=1:nrow(data.test.subject)]
#setkey(data.test.subject, id)
#setnames(data.test.subject, c("subject", "id"))
setnames(data.test.subject,"subject")

# bind columns
data.test <- cbind(data.test.x, data.test.y)
data.test <- cbind(data.test, data.test.subject)

# release unused memory
rm(data.test.x)
rm(data.test.y)
rm(data.test.subject)

## train data

# reading measurements
data.train.x <- data.table(read.table(unz(zippedDataset, "UCI HAR Dataset/train/X_train.txt")))
#data.test.x[, id:=1:nrow(data.test.x)] # adding a id to the dataset -> use a function for that operation
#setkey(data.test.x, id) # define a key

## specifying column names
#setnames(data.test.x, c("id", as.character(features$feature)))
setnames(data.train.x, as.character(features$feature))

# reading activities
data.train.y <- data.table(read.table(unz(zippedDataset, "UCI HAR Dataset/train/y_train.txt")))
#data.test.y[, id:=1:nrow(data.test.y)] # adding a id to the dataset -> use a function for that operation
#setkey(data.test.y, id) # define a key
#setnames(data.test.y, c("activity", "id"))
setnames(data.train.y, "activity_id")

#reading subjects
data.train.subject <- data.table(read.table(unz(zippedDataset, "UCI HAR Dataset/train/subject_train.txt")))
#data.test.subject[, id:=1:nrow(data.test.subject)]
#setkey(data.test.subject, id)
#setnames(data.test.subject, c("subject", "id"))
setnames(data.train.subject,"subject")

# bind columns
data.train <- cbind(data.train.x, data.train.y)
data.train <- cbind(data.train, data.train.subject)

# release unused memory
rm(data.train.x)
rm(data.train.y)
rm(data.train.subject)
rm(features)


# merge datasets together
print("merging data")
l <- list(data.test, data.train)
data.merged <- rbindlist(l, use.names=TRUE, fill=TRUE)


## free some memory
rm(l)
rm(data.train)
rm(data.test)

############################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

print("extracting needed columns")
data <- data.merged[, grep("std|mean|activity|subject", names(data.merged)), with=FALSE]
rm(data.merged)

############################################################################################
# 3. Uses descriptive activity names to name the activities in the data set

print("labelling activities")
# obtain activiy labels
activities <- data.table(read.table(unz(zippedDataset, "UCI HAR Dataset/activity_labels.txt"), 
                                  col.names=c("activity_id", "activity"), 
                                  stringsAsFactors=FALSE))

# factorize the activity column in the data set
#data.labelled <- merge(data, activities, by.x="activity", by.y="id", all=TRUE)
data <- merge(data, activities, by="activity_id", all=TRUE)
data[, activity_id := NULL]

#cleaning up activities
rm(activities)
rm(zippedDataset)

############################################################################################
# 4. Appropriately labels the data set with descriptive variable names. 
print("cleaning up variable names")
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

############################################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#     average of each variable for each activity and each subject.

##data2 <- aggregate(. ~subject + activity, data, mean)
##data2 <- data2[order(data2$subject,data2$activity),]

print("generating a second set for writing")
data.melt <- melt(data, id=c("activity", "subject"))
data.tidy <- dcast(data.melt, activity + subject ~ variable, mean)

rm(data)
rm(data.melt)

print("writing to output")
## finallywrite a csv file
write.table(data.tidy, "tidyData.txt", row.name = FALSE)

rm(data.tidy)
