# remove any old files and clean up workspace
rm(list=ls(all=TRUE))

# call appropriate libraries for functions
library(data.table)
library(dplyr)
library(knitr)
library(markdown)

# create working directory if it does not already exist
if (!getwd() == "D:/R_workplace/DataScienceSpecialization/getting_and_cleaning_data/data")
   { dir.create("D:/R_workplace/DataScienceSpecialization/getting_and_cleaning_data/data")
}

# set working directory and assign it to wd
setwd("D:/R_workplace/DataScienceSpecialization/getting_and_cleaning_data/data")
wd <- getwd()

# assign dataset zipfile to a
a <- "Dataset.zip"

# assign url for file location to fileUrl
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# download file using assigned parameters
download.file(fileUrl, file.path(wd, a))

# extract list of all files in the zip file and assign to p
p <- unzip(file.path(wd, a), list=TRUE)

# view files in zip archive
p

# remove any files with Inertial in name as they are not part of the data analysis
p <- p[grep("Inertial", p$Name, invert=TRUE),1]

# unzip only files that are necessary for the data analysis project
# collapse folder structure so that all files are in working directory
unzip(file.path(wd, a),files= p, junkpaths=TRUE)

# once files are unzipped then view README.txt in order to understand construction of 
# data files and how they can be combined into a dataset to be analyzed

# read test and train .txt data files into data tables in working directory
test_data  <- fread(file.path(wd, "X_test.txt"))
train_data  <- fread(file.path(wd, "X_train.txt"))

# examine size of data tables to get first indication of their dimensions
dim(test_data)
dim(train_data)

# examine names of columns in test and train files to determine if they are similar
names(test_data) == names(train_data)

# read test and train activity label .txt files into data tables in working directory
test_label <- fread(file.path(wd, "y_test.txt"))
train_label <- fread(file.path(wd, "y_train.txt"))

# examine structure of test and train activity label data tables
str(test_label)
str(train_label)

# determine count of label activities that exist in both test and train label data tables
table(test_label)
table(train_label)

# read features .txt file into data table so column names can be attached to test and 
# train data tables and examine
features <- fread(file.path(wd, "features.txt"))
head(features)

# read activity labels .txt files into data table and then examine so we know what 
# types of activities are being evaluated 
activities <- fread(file.path(wd, "activity_labels.txt"))
head(activities)

# examine structure of features and activities data tables
str(features)
str(activities)

# read subject test and train .txt files into data tables so they can be used to specify
# which subjects performed which activity and the respective captured data 
subject_test <- fread(file.path(wd, "subject_test.txt"))
subject_train <- fread(file.path(wd, "subject_train.txt"))

# examine the structure of the test and train subject data tables
str(subject_test)
str(subject_train)

# now that all data sets have been examined and the README and features_info text files 
# have been read, it is time to begin to merge the data sets as per the instructions
# Use rbind to row bind the respective train and test data sets for the main data, the 
# activity label data, and the subject data
data_all <- rbind(train_data, test_data)
label_all <- rbind(train_label, test_label)
subject_all <- rbind(subject_train, subject_test)

# examine the dimensions of the combined main data set, the combined activity label data 
# set, and the combined subject data set
dim(data_all)
dim(label_all)
dim(subject_all)

# now extract only measurements on the mean and standard deviation for each measurement
# step 1 is to determine which columns have mean [mean()] and standard deviation [std()]
# in them
# only variables with the mean or standard deviation of the entire variable are examined 
# (this results in only including variables which have mean() or std() at the end of the 
# name)
data_col <- features[grep("mean\\(\\)|std\\(\\)", V2)]

# step 2 is to extract the first column from the resulting data table and append "v" to
# the front of each variable in order to create a link variable so that we can map the 
# extracted features to the main data column names
coll <- data_col[[1]]
coll <- paste0("V", coll)
head(coll)

# step 3 is to use the resultant link vector for the extracted features with mean and 
# standard deviation measurements to subset the main data table into the columns that
# are required for the analysis
data_all <- data_all[,coll, with= FALSE]

# check that the vector of link variables matches the column names of the extracted main
# data set to ensure that the relative ordering of the variables is the same
names(data_all) == coll

# next replace the variable names in the columns with the more decriptive feature labels
# also replace the column names in label_all, activities, and subject_all data tables
# so that when they are combined they will have the correct column names
setnames(data_all, names(data_all), data_col$V2)
setnames(label_all, "V1", "Link")
setnames(activities, "V1", "Link")
setnames(activities, "V2", "Activities")
setnames(subject_all, "V1", "Subject")

# combine the subject data table with the activity label data table and the extracted
# main data data table
data_all <- cbind(subject_all, label_all, data_all)

# at this point the column names are still fairly cryptic and since we desire easily
# understandable names, we replace the abbreviations with the actual word in the data
# table columns - this results in descriptive column names for the respective 
# measurements that can be easily read and understood
names(data_all) <- gsub("^t", "time_", names(data_all))
names(data_all) <- gsub("^f", "frequency_", names(data_all))
names(data_all) <- gsub("Acc", "_Acceleration", names(data_all))
names(data_all) <- gsub("Gyro", "_Gyroscope", names(data_all))
names(data_all) <- gsub("Jerk", "_Jerk", names(data_all))
names(data_all) <- gsub("Mag", "_Magnitude", names(data_all))
names(data_all) <- gsub("BodyBody", "Body_Body", names(data_all))

# next merge the main data table with the activities data table do the activities in the 
# main data table have desctiptive names and are readily understandable
data_all <- merge(data_all, activities, "Link")

# remove the "Link" variable that was used to merge the data tables
data_all$Link <- NULL

# set column order so that SUbject is in the first column and Activites are in the 
# second column and the additional columns follow in their respective order
setcolorder(data_all, c("Subject", "Activities", colnames(data_all)[!(colnames(data_all) 
    %in% c("Subject", "Activities"))]))

# designate the columns for Subject and Activities are factors to facilitate additional 
# analysis
data_all$Subject <- factor(data_all$Subject)
data_all$Activities <- factor(data_all$Activities)

# create vector of all measurement variables to facilitate the translation from a wide
# data table to a narrow data table with all measurements in one column using melt in the 
# next data step
mysubset <- colnames(data_all)[!(colnames(data_all) 
                                  %in% c("Subject", "Activities"))]

# create a narrow data table with the types of measurement for each Subject and Activities
# combination in one column and the resulting value of the measurements in another column
# this is the long form of tidy data as mentioned in the rubric as either long or wide 
# form is acceptable
data_all_narrow <- melt(data_all, c("Subject", "Activities"), mysubset, variable.name= 
    "Measurement")

# complete the second independent tidy data set in the data table by grouping the data by
# each Subject and each activity and calculating the respective average for each
# grouped variable
# this is the long form of tidy data as mentioned in the rubric as either long or wide 
# form is acceptable
# the principles of tidy data are:
# In tidy data:
# 1. Each variable forms a column.
# 2. Each observation forms a row.
# 3. Each type of observational unit forms a table.
# see Wickham, Hadley, "Tidy Data", Journal of Statistical Software, MMMMMM YYYY, 
# Volume VV, Issue II. http://www.jstatsoft.org/
tidy_data <- data_all_narrow %>% group_by(Subject, Activities, Measurement) %>% 
    summarize(Average= mean(value))

#examine resulting tidy data set
head(tidy_data,n=15)

# write tidy_data to .txt file
write.table(tidy_data, "HumanActivityRecognitionUsingSmartphones.txt")

# read tidy_data.txt
final_tidy_data <- read.table("HumanActivityRecognitionUsingSmartphones.txt", header= TRUE)
view(final_tidy_data)

# Create run_analysis.md

knit("run_analysis.Rmd", encoding="ISO8859-1")
markdownToHTML("run_analysis.md", "run_analysis.html")
