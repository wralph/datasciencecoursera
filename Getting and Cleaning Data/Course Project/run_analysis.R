##
# Write a header describing the file
##

library(dplyr)

#global variables
zippedDataset <- "dataset.zip"
dataDirectory <- "data"

# download dataset
zip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zip, zippedDataset)
#close open connection
close(zip)

#print("unzipping downloaded file")
#unzip(zippedDataset, files = NULL, list = FALSE, overwrite = TRUE,
#      junkpaths = TRUE, exdir = dataDirectory, unzip = "internal",setTimes = FALSE)

## 1. Merges the training and the test sets to create one data set.
## obtaining feature information
features <- data.table(read.table(unz("dataset.zip", "UCI HAR Dataset/features.txt"), 
                                  col.names=c("id", "feature"), 
                                  stringsAsFactors=FALSE))
                                  
# read data from zipfile
print("reading data")

## test data
# reading measurements
data.test.x <- data.table(read.table(unz(zippedDataset, "UCI HAR Dataset/test/X_test.txt")))
data.test.x[, id:=1:nrow(data.test.x)] # adding a id to the dataset -> use a function for that operation
setkey(data.test.x, id) # define a key

## specifying column names
setnames(data.test.x, c("id", as.character(features$feature)))

# reading activities
data.test.y <- data.table(read.table(unz("dataset.zip", "UCI HAR Dataset/test/y_test.txt")))
data.test.y[, id:=1:nrow(data.test.y)] # adding a id to the dataset -> use a function for that operation
setkey(data.test.y, id) # define a key
setnames(data.test.y, c("activity", "id"))

#reading subjects
data.test.subject <- data.table(read.table(unz("dataset.zip", "UCI HAR Dataset/test/subject_test.txt")))
data.test.subject[, id:=1:nrow(data.test.subject)]
setkey(data.test.subject, id)
setnames(data.test.subject, c("subject", "id"))

## train data

# reading measurements
data.train.x <- data.table(read.table(unz(zippedDataset, "UCI HAR Dataset/train/X_train.txt")))
data.train.x[, id:=1:nrow(data.train.x)] # adding a id to the dataset
setkey(data.train.x, id) # define a key

## specifying column names
setnames(data.train.x, c("id", as.character(features$feature)))

# reading activities
data.train.y <- data.table(read.table(unz(zippedDataset, "UCI HAR Dataset/train/y_train.txt")))
data.train.y[, id:=1:nrow(data.train.y)] # adding a id to the dataset
setkey(data.train.y, id) # define a key
setnames(data.train.y, c("activity", "id"))

#reading subjects
data.train.subject <- data.table(read.table(unz("dataset.zip", "UCI HAR Dataset/train/subject_train.txt")))
data.train.subject[, id:=1:nrow(data.train.subject)]
setkey(data.train.subject, id)
setnames(data.train.subject, c("subject", "id"))

# TODO: use use merge to merge the data together



# merge datasets together
print("merging data")
l <- list(data.test, data.train)
data.merged <- rbindlist(lm, use.names=TRUE, fill=true)

## get rid of the initial datasets to free some memory
rm(data.train)
rm(data.test)

#obtain feature description
features <- data.table(read.table(unz("dataset.zip", "UCI HAR Dataset/features.txt"), 
                                  col.names=c("id", "feature"), 
                                  stringsAsFactors=FALSE))

setnames(data.merged, as.character(features$feature))
# TODO: take care about the extra column for the activity


## Extracts only the measurements on the mean and standard deviation for each measurement. 
data.selected <- data.merged[,grepl("std|mean", colnames(data.merged))]


## finallywrite a csv file
write.csv(DT_HAR_tidy, FILE_output, row.names = FALSE)
