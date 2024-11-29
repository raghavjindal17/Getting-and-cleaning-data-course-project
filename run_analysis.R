library(tidyverse)

# Original source file downloaded 8/31/2024
# The following will load the files to the current working directory.
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
tempFile <- "UCI_HAR_Dataset.zip"
download.file(url, tempFile)
unzip(tempFile)
file.remove(tempFile)

# load feature and activity labels
feature_labels <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# load test data sets
test_data_X <- read.table("UCI HAR Dataset/test/X_test.txt")
test_data_y <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# create test df with feature_labels, test_data_y as activity_int, and subject_test as subject
label_names <- feature_labels[, 2]
colnames(test_data_X) <- label_names

test_data <- cbind(test_data_y,test_data_X)
test_data <- cbind(subject_test,test_data)
names(test_data)[1] <- "subject_number"
names(test_data)[2] <- "activity_int"

# load train data sets
train_data_X <- read.table("UCI HAR Dataset/train/X_train.txt")
train_data_y <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# create train df with feature_labels, train_data_y as activity_int,
# and subject_train as subject
colnames(train_data_X) <- label_names

train_data <- cbind(train_data_y,train_data_X)
train_data <- cbind(subject_train,train_data)
names(train_data)[1] <- "subject_number"
names(train_data)[2] <- "activity_int"

# combine the two data sets
HAR_data <- rbind(test_data, train_data)

# select columns that reference means and standard deviations
HAR_data_sel <- HAR_data %>% 
    select(subject_number, activity_int, contains("mean"), contains("std") )

# Add in the activity labels based on the activity_int variable.
# (this is done at this point as the HAR_data has columns with duplicate names,
# which is not unusual for complex sensor data, but causes errors in R joins().)
HAR_data_sel <- HAR_data_sel %>%
    left_join(activity_labels, by = c("activity_int" = "V1")) %>%
    rename(activity_label = V2) %>%
    relocate(activity_label, .after = activity_int)

# Create groups by activity_label within subject_number
HAR_data_group <- HAR_data_sel %>% 
    group_by(subject_number, activity_label) %>% 
    summarise_all(mean, na.rm = TRUE, exclude = c("column3"))
head(HAR_data_group)

# If desired write out a text file copy of the tidy group data set
write.table(HAR_data_group, file= "HAR_Groups.txt",row.name=FALSE)



