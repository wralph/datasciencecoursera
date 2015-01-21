## Description for run_analysis.R

This project contains an R script named "run_analysis.R". It can be 
executed from an R console with the command

```R
	source("run_analysis.R")
```

The script will obtain a dataset from the following address:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

It processes a tidy dataset named tidyData.txt which is a data set with the average of each variable for each activity and each subject.

A detailed description of the contents of the zip file can be found here.

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 


The executed steps are the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

