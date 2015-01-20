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

print("unzipping downloaded file")
unzip(zippedDataset, files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = TRUE, exdir = dataDirectory, unzip = "internal",setTimes = FALSE)

## 1. Merges the training and the test sets to create one data set.

# read data from zipfile
print("reading data")
# use unz again
data.test <- data.table(read.table(paste(dataDirectory, "/X_test.txt", sep="")))
data.train <- data.table(read.table(paste(dataDirectory, "/X_train.txt", sep="")))

# TODO: get the Y_test.txt and Y_train.txt for the activities

# TODO: use use merge to merge the data together



# merge datasets together
print("merging data")
l <- list(data.test, data.train)
data.merged <- rbindlist(lm, use.names=TRUE, fill=true)

## get rid of the initial datasets to free some memory
rm(data.train)
rm(data.test)

#obtain feature description
features <- data.table(read.table("data/features.txt", 
                                  col.names=c("id", "feature"), 
                                  stringsAsFactors=FALSE))

setnames(data.merged, as.character(features$feature))
# TODO: take care about the extra column for the activity


## Extracts only the measurements on the mean and standard deviation for each measurement. 
data.selected <- data.merged[,grepl("std|mean", colnames(data.merged))]


## finallywrite a csv file
write.csv(DT_HAR_tidy, FILE_output, row.names = FALSE)