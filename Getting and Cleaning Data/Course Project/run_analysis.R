#global variables
zippedDataset <- "dataset.zip"

# download dataset
zip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zip, zippedDataset)

data <- read.table(unz(zippedDataset, "a1.dat"))