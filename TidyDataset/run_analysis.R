# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. 
# You will be graded by your peers on a series of yes/no questions related to the project. 
# You will be required to submit: 
#   1) a tidy data set as described below, 
#   2) a link to a Github repository with your script for performing the analysis, and 
#   3) a code book that describes the variables, the data, and any transformations or work that you performed 
#   to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. 
#   This repo explains how all of the scripts work and how they are connected.  
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . 
# Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
# The data linked to from the course website represent data collected from the accelerometers from the 
# Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
#   
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# 
# Here are the data for the project: 
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive activity names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# Good luck!

## STEP 1 : Merges the training and the test sets to create one data set.
## STEP 2 : Uses descriptive activity names to name the activities in the data set
## STEP 3 : Appropriately labels the data set with descriptive activity names. 

# directory containing all datasets
dataset.dir <- "./UCI HAR Dataset"

# read activity_labels file and rename variables
activity_labels <- read.table(file = paste(dataset.dir,"activity_labels.txt",sep='/'),
                              sep = ' ',
                              stringsAsFactors = FALSE)
names(activity_labels) <- c('activity_id', 'activity_label')
str(activity_labels)

# read features file and rename variables
features <- read.table(file = paste(dataset.dir,"features.txt",sep='/'),
                              sep = ' ',
                              stringsAsFactors = FALSE)
names(features) <- c('feature_id', 'feature_label')
str(features)

# read trainset files, merge them and rename variables
train <- read.table(file = paste(dataset.dir,"train","X_train.txt",sep='/'), 
                    sep = "",
                    header = FALSE,
                    stringsAsFactors = FALSE,
                    strip.white = TRUE)
names(train) <- features$feature_label
str(train)

subject.train <- read.table(file = paste(dataset.dir,"train","subject_train.txt",sep='/'), 
                            sep = "",
                            header = FALSE,
                            stringsAsFactors = FALSE,
                            strip.white = TRUE)
names(subject.train) <- "subject"
str(subject.train)

y.train <- read.table(file = paste(dataset.dir,"train","y_train.txt",sep='/'), 
                            sep = "",
                            header = FALSE,
                            stringsAsFactors = FALSE,
                            strip.white = TRUE)
names(y.train) <- "activity_id"
str(y.train)
y.train <- merge(y.train, activity_labels, by.x = "activity_id", by.y = "activity_id", all.x = TRUE)
str(y.train)

trainset <- cbind(subject.train, train, y.train)
str(trainset)

# read test files, merge them and rename variables
test <- read.table(file = paste(dataset.dir,"test","X_test.txt",sep='/'), 
                    sep = "",
                    header = FALSE,
                    stringsAsFactors = FALSE,
                    strip.white = TRUE)
names(test) <- features$feature_label
str(test)

subject.test <- read.table(file = paste(dataset.dir,"test","subject_test.txt",sep='/'), 
                            sep = "",
                            header = FALSE,
                            stringsAsFactors = FALSE,
                            strip.white = TRUE)
names(subject.test) <- "subject"
str(subject.test)

y.test <- read.table(file = paste(dataset.dir,"test","y_test.txt",sep='/'), 
                      sep = "",
                      header = FALSE,
                      stringsAsFactors = FALSE,
                      strip.white = TRUE)
names(y.test) <- "activity_id"
str(y.test)
y.test <- merge(y.test, activity_labels, by.x = "activity_id", by.y = "activity_id", all.x = TRUE)
str(y.test)

testset <- cbind(subject.test, test, y.test)
str(testset)

# merge train and test set
dataset <- rbind(trainset,testset)
str(dataset)

# save it for future reading
# write.table(dataset,file="dataset.txt", row.names = FALSE, col.names = TRUE, sep = "\t")
# dataset <- read.table(file="dataset.txt", sep = "\t", header = TRUE)

# at this point dataset contains the train and test sets, plus the subject and activity labels

## STEP 4 : Extracts only the measurements on the mean and standard deviation for each measurement. 

# get the features wiht "mean()" and "std()" in the features names
keep.features.mean <- grep(pattern= "mean()", names(dataset), fixed = TRUE)
keep.features.std <- grep(pattern= "std()", names(dataset), fixed = TRUE)
keep.features <- sort(c(keep.features.mean, keep.features.std), decreasing = FALSE)

# get the variables of interest from the dataset
keep.dataset <- dataset[,keep.features]
subjects <- as.factor(dataset$subject)
activities <- as.factor(dataset$activity_label)

# and merge them into a new dataset
dataset.new <- cbind(subjects, keep.dataset, activities)

## STEP 5 : Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# load library that will help summarizing the data
library(data.table) 
# convert dataset.new to a data.table object
dataset.new.dt <- as.data.table(dataset.new)
# compute the mean for all the varibales (.SD) by subjects and activities
tidy.dataset <- dataset.new.dt[ , lapply(.SD, mean, na.rm=TRUE), by=list(subjects, activities)]

# save it for future reading
write.table(tidy.dataset,file="tidy_dataset.txt", row.names = FALSE, col.names = TRUE, sep = "\t")
