---
title: "run_analysis"
author: "skewdlogix"
date: "March 18, 2017"
output: html_document
---



## Getting and Cleaning Data Course Project

### Introduction

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.  The required submissions are: 1) a tidy data set as described below, 2) a link to a Github repository with a script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that were performed to clean up the data called CodeBook.md. In addition, a README.md should also be included in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

There also is an R script called run_analysis.R that does the following.

   1) Merges the training and the test sets to create one data set.
   2) Extracts only the measurements on the mean and standard deviation for each measurement.
   3) Uses descriptive activity names to name the activities in the data set
   4) Appropriately labels the data set with descriptive variable names.
   5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
   
### Initial Workspace Preparation

Remove any old files and clean up workspace

```r
rm(list=ls(all=TRUE))
```

Call appropriate libraries for functions


```r
library(data.table)
library(dplyr)
library(knitr)
library(markdown)
```

Create working directory if it does not already exist


```r
if (!getwd() == "D:/R_workplace/DataScienceSpecialization/getting_and_cleaning_data/data")
   { dir.create("D:/R_workplace/DataScienceSpecialization/getting_and_cleaning_data/data")
}
```

Set working directory and assign it to wd


```r
setwd("D:/R_workplace/DataScienceSpecialization/getting_and_cleaning_data/data")
wd <- getwd()
```

### Download Data Files and Unzip Files to be Analyzed

Assign dataset zipfile to a  
Assign url for file location to fileUrl  
Download file using assigned parameters


```r
a <- "Dataset.zip"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, file.path(wd, a))
```

Extract list of all files in the zip file and assign to p  
View files in zip archive


```r
p <- unzip(file.path(wd, a), list=TRUE)
p
```

```
##                                                            Name   Length
## 1                           UCI HAR Dataset/activity_labels.txt       80
## 2                                  UCI HAR Dataset/features.txt    15785
## 3                             UCI HAR Dataset/features_info.txt     2809
## 4                                    UCI HAR Dataset/README.txt     4453
## 5                                         UCI HAR Dataset/test/        0
## 6                        UCI HAR Dataset/test/Inertial Signals/        0
## 7     UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt  6041350
## 8     UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt  6041350
## 9     UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt  6041350
## 10   UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt  6041350
## 11   UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt  6041350
## 12   UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt  6041350
## 13   UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt  6041350
## 14   UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt  6041350
## 15   UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt  6041350
## 16                        UCI HAR Dataset/test/subject_test.txt     7934
## 17                              UCI HAR Dataset/test/X_test.txt 26458166
## 18                              UCI HAR Dataset/test/y_test.txt     5894
## 19                                       UCI HAR Dataset/train/        0
## 20                      UCI HAR Dataset/train/Inertial Signals/        0
## 21  UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt 15071600
## 22  UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt 15071600
## 23  UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt 15071600
## 24 UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt 15071600
## 25 UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt 15071600
## 26 UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt 15071600
## 27 UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt 15071600
## 28 UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt 15071600
## 29 UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt 15071600
## 30                      UCI HAR Dataset/train/subject_train.txt    20152
## 31                            UCI HAR Dataset/train/X_train.txt 66006256
## 32                            UCI HAR Dataset/train/y_train.txt    14704
##                   Date
## 1  2012-10-10 15:55:00
## 2  2012-10-11 13:41:00
## 3  2012-10-15 15:44:00
## 4  2012-12-10 10:38:00
## 5  2012-11-29 17:01:00
## 6  2012-11-29 17:01:00
## 7  2012-11-29 15:08:00
## 8  2012-11-29 15:08:00
## 9  2012-11-29 15:08:00
## 10 2012-11-29 15:09:00
## 11 2012-11-29 15:09:00
## 12 2012-11-29 15:09:00
## 13 2012-11-29 15:08:00
## 14 2012-11-29 15:09:00
## 15 2012-11-29 15:09:00
## 16 2012-11-29 15:09:00
## 17 2012-11-29 15:25:00
## 18 2012-11-29 15:09:00
## 19 2012-11-29 17:01:00
## 20 2012-11-29 17:01:00
## 21 2012-11-29 15:08:00
## 22 2012-11-29 15:08:00
## 23 2012-11-29 15:08:00
## 24 2012-11-29 15:09:00
## 25 2012-11-29 15:09:00
## 26 2012-11-29 15:09:00
## 27 2012-11-29 15:08:00
## 28 2012-11-29 15:08:00
## 29 2012-11-29 15:08:00
## 30 2012-11-29 15:09:00
## 31 2012-11-29 15:25:00
## 32 2012-11-29 15:09:00
```

Remove any files with "Inertial"" in name as they are not part of the data analysis  
View file names of files to be extracted


```r
p <- p[grep("Inertial", p$Name, invert=TRUE),1]
p
```

```
##  [1] "UCI HAR Dataset/activity_labels.txt"    
##  [2] "UCI HAR Dataset/features.txt"           
##  [3] "UCI HAR Dataset/features_info.txt"      
##  [4] "UCI HAR Dataset/README.txt"             
##  [5] "UCI HAR Dataset/test/"                  
##  [6] "UCI HAR Dataset/test/subject_test.txt"  
##  [7] "UCI HAR Dataset/test/X_test.txt"        
##  [8] "UCI HAR Dataset/test/y_test.txt"        
##  [9] "UCI HAR Dataset/train/"                 
## [10] "UCI HAR Dataset/train/subject_train.txt"
## [11] "UCI HAR Dataset/train/X_train.txt"      
## [12] "UCI HAR Dataset/train/y_train.txt"
```

Unzip only files that are necessary for the data analysis project  
Collapse folder structure so that all files are in working directory


```r
unzip(file.path(wd, a),files= p, junkpaths=TRUE)
```

Once files are unzipped then view README.txt in order to understand construction of data files and how they can be combined into a dataset to be analyzed

### Read Data Files into Workspace and Examine Characteristics

Read test and train .txt data files into data tables in working directory  
Examine size of data tables to get first indication of their dimensions


```r
test_data  <- fread(file.path(wd, "X_test.txt"))
train_data  <- fread(file.path(wd, "X_train.txt"))
dim(test_data)
```

```
## [1] 2947  561
```

```r
dim(train_data)
```

```
## [1] 7352  561
```

Examine names of columns in test and train files to determine if they are similar


```r
names(test_data) == names(train_data)
```

```
##   [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
##  [15] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
##  [29] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
##  [43] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
##  [57] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
##  [71] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
##  [85] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
##  [99] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [113] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [127] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [141] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [155] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [169] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [183] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [197] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [211] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [225] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [239] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [253] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [267] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [281] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [295] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [309] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [323] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [337] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [351] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [365] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [379] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [393] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [407] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [421] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [435] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [449] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [463] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [477] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [491] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [505] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [519] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [533] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [547] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [561] TRUE
```

Read test and train activity label .txt files into data tables in working directory  
Examine structure of test and train activity label data tables  
Determine count of label activities that exist in both test and train label data tables


```r
test_label <- fread(file.path(wd, "y_test.txt"))
train_label <- fread(file.path(wd, "y_train.txt"))
str(test_label)
```

```
## Classes 'data.table' and 'data.frame':	2947 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
str(train_label)
```

```
## Classes 'data.table' and 'data.frame':	7352 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
table(test_label)
```

```
## test_label
##   1   2   3   4   5   6 
## 496 471 420 491 532 537
```

```r
table(train_label)
```

```
## train_label
##    1    2    3    4    5    6 
## 1226 1073  986 1286 1374 1407
```

Read features .txt file into data table so column names can be attached to test and train data tables and examine


```r
features <- fread(file.path(wd, "features.txt"))
head(features)
```

```
##    V1                V2
## 1:  1 tBodyAcc-mean()-X
## 2:  2 tBodyAcc-mean()-Y
## 3:  3 tBodyAcc-mean()-Z
## 4:  4  tBodyAcc-std()-X
## 5:  5  tBodyAcc-std()-Y
## 6:  6  tBodyAcc-std()-Z
```

Read activity labels .txt files into data table and then examine so we know what types of activities are being evaluated 


```r
activities <- fread(file.path(wd, "activity_labels.txt"))
head(activities)
```

```
##    V1                 V2
## 1:  1            WALKING
## 2:  2   WALKING_UPSTAIRS
## 3:  3 WALKING_DOWNSTAIRS
## 4:  4            SITTING
## 5:  5           STANDING
## 6:  6             LAYING
```

Examine structure of features and activities data tables


```r
str(features)
```

```
## Classes 'data.table' and 'data.frame':	561 obs. of  2 variables:
##  $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
##  $ V2: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
str(activities)
```

```
## Classes 'data.table' and 'data.frame':	6 obs. of  2 variables:
##  $ V1: int  1 2 3 4 5 6
##  $ V2: chr  "WALKING" "WALKING_UPSTAIRS" "WALKING_DOWNSTAIRS" "SITTING" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

Read subject test and train .txt files into data tables so they can be used to specify which subjects performed which activity and the respective captured data  
Examine the structure of the test and train subject data tables


```r
subject_test <- fread(file.path(wd, "subject_test.txt"))
subject_train <- fread(file.path(wd, "subject_train.txt"))
str(subject_test)
```

```
## Classes 'data.table' and 'data.frame':	2947 obs. of  1 variable:
##  $ V1: int  2 2 2 2 2 2 2 2 2 2 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
str(subject_train)
```

```
## Classes 'data.table' and 'data.frame':	7352 obs. of  1 variable:
##  $ V1: int  1 1 1 1 1 1 1 1 1 1 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```


### Merge Data Sets

Now that all data sets have been examined and the README and features_info text files have been read, it is time to begin to merge the data sets as per the instructions  
Use rbind to row bind the respective train and test data sets for the main data, the activity label data, and the subject data  
Examine the dimensions of the combined main data set, the combined activity label data set, and the combined subject data set


```r
data_all <- rbind(train_data, test_data)
label_all <- rbind(train_label, test_label)
subject_all <- rbind(subject_train, subject_test)
dim(data_all)
```

```
## [1] 10299   561
```

```r
dim(label_all)
```

```
## [1] 10299     1
```

```r
dim(subject_all)
```

```
## [1] 10299     1
```

### Extract Measurements for Mean and Standard Deviation Only

Now extract only measurements on the mean and standard deviation for each measurement  

Step 1 is to determine which columns have mean [mean()] and standard deviation [std()] in them  
Only variables with the mean or standard deviation of the entire variable are examined (this results in only including variables which have mean() or std() at the end of the variable name)


```r
data_col <- features[grep("mean\\(\\)|std\\(\\)", V2)]
```

Step 2 is to extract the first column from the resulting data table and append "v" to the front of each variable in order to create a link variable so that we can map the extracted features to the main data column names


```r
coll <- data_col[[1]]
coll <- paste0("V", coll)
head(coll)
```

```
## [1] "V1" "V2" "V3" "V4" "V5" "V6"
```

Step 3 is to use the resultant link vector for the extracted features with mean and standard deviation measurements to subset the main data table into the columns that are required for the analysis


```r
data_all <- data_all[,coll, with= FALSE]
```

Check that the vector of link variables matches the column names of the extracted main data set to ensure that the relative ordering of the variables is the same


```r
names(data_all) == coll
```

```
##  [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [15] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [29] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [43] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [57] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
```


### Appropriately Label the Data Set with Descriptive Variable Names

Next replace the variable names in the columns with the more decriptive feature labels also replace the column names in label_all, activities, and subject_all data tables so that when they are combined they will have the correct column names


```r
setnames(data_all, names(data_all), data_col$V2)
setnames(label_all, "V1", "Link")
setnames(activities, "V1", "Link")
setnames(activities, "V2", "Activities")
setnames(subject_all, "V1", "Subject")
```

Combine the subject data table with the activity label data table and the extracted main data data table


```r
data_all <- cbind(subject_all, label_all, data_all)
```

At this point the column names are still fairly cryptic and since we desire easily understandable names, we replace the abbreviations with the actual word in the data table columns - this results in descriptive column names for the respective measurements that can be easily read and understood


```r
names(data_all) <- gsub("^t", "time_", names(data_all))
names(data_all) <- gsub("^f", "frequency_", names(data_all))
names(data_all) <- gsub("Acc", "_Acceleration", names(data_all))
names(data_all) <- gsub("Gyro", "_Gyroscope", names(data_all))
names(data_all) <- gsub("Jerk", "_Jerk", names(data_all))
names(data_all) <- gsub("Mag", "_Magnitude", names(data_all))
names(data_all) <- gsub("BodyBody", "Body_Body", names(data_all))
```


### Use Descriptive Activity Names to Name the Activities in the Data Set

Next merge the main data table with the activities data table so the activities in the main data table have desctiptive names and are readily understandable  
Remove the "Link" variable that was used to merge the data tables


```r
data_all <- merge(data_all, activities, "Link")
data_all$Link <- NULL
```

Set column order so that Subject is in the first column and Activites are in the second column and the additional columns follow in their respective order


```r
setcolorder(data_all, c("Subject", "Activities", colnames(data_all)[!(colnames(data_all) 
    %in% c("Subject", "Activities"))]))
```


### Create Tidy Data Set from the Aggregated Data Table

Designate the columns for Subject and Activities are factors to facilitate additional analysis


```r
data_all$Subject <- factor(data_all$Subject)
data_all$Activities <- factor(data_all$Activities)
```

Create vector of all measurement variables to facilitate the translation from a wide data table to a narrow data table with all measurements in one column using melt in the next data step  
Create a narrow data table with the types of measurement for each Subject and Activities combination in one column and the resulting value of the measurements in another column  
This is the long form of tidy data as mentioned in the rubric as either long or wide form is acceptable


```r
mysubset <- colnames(data_all)[!(colnames(data_all) 
                                  %in% c("Subject", "Activities"))]
data_all_narrow <- melt(data_all, c("Subject", "Activities"), mysubset, variable.name= 
    "Measurement")
```

### Creates a Second, Independent Tidy Data Set with the Average of Each Variable for Each Activity and Each Subject

Complete the second, independent tidy data set in the data table by grouping the data by each subject and each activity and calculating the respective average for each grouped variable. This is the long form of tidy data as mentioned in the rubric as either long or wide form is acceptable.  
The principles of tidy data are:  
   1. Each variable forms a column.  
   2. Each observation forms a row.  
   3. Each type of observational unit forms a table.  
See Wickham, Hadley, "Tidy Data", Journal of Statistical Software, MMMMMM YYYY, Volume VV, Issue II. http://www.jstatsoft.org/


```r
tidy_data <- data_all_narrow %>% group_by(Subject, Activities, Measurement) %>% 
    summarize(Average= mean(value))
```

Examine resulting tidy data set


```r
head(tidy_data,n=15)
```

```
## Source: local data frame [15 x 4]
## Groups: Subject, Activities [1]
## 
##    Subject Activities                          Measurement      Average
##     <fctr>     <fctr>                               <fctr>        <dbl>
## 1        1     LAYING      time_Body_Acceleration-mean()-X  0.221598244
## 2        1     LAYING      time_Body_Acceleration-mean()-Y -0.040513953
## 3        1     LAYING      time_Body_Acceleration-mean()-Z -0.113203554
## 4        1     LAYING       time_Body_Acceleration-std()-X -0.928056469
## 5        1     LAYING       time_Body_Acceleration-std()-Y -0.836827406
## 6        1     LAYING       time_Body_Acceleration-std()-Z -0.826061402
## 7        1     LAYING   time_Gravity_Acceleration-mean()-X -0.248881798
## 8        1     LAYING   time_Gravity_Acceleration-mean()-Y  0.705549773
## 9        1     LAYING   time_Gravity_Acceleration-mean()-Z  0.445817720
## 10       1     LAYING    time_Gravity_Acceleration-std()-X -0.896830018
## 11       1     LAYING    time_Gravity_Acceleration-std()-Y -0.907720007
## 12       1     LAYING    time_Gravity_Acceleration-std()-Z -0.852366290
## 13       1     LAYING time_Body_Acceleration_Jerk-mean()-X  0.081086534
## 14       1     LAYING time_Body_Acceleration_Jerk-mean()-Y  0.003838204
## 15       1     LAYING time_Body_Acceleration_Jerk-mean()-Z  0.010834236
```

Write tidy_data to .txt file


```r
write.table(tidy_data, "HumanActivityRecognitionUsingSmartphones.txt", row.names= FALSE)
```

read HumanActivityRecognitionUsingSmartphones.txt


```r
final_tidy_data <- read.table("HumanActivityRecognitionUsingSmartphones.txt", header= TRUE)
View(final_tidy_data)
```

Create Codebook.md


```r
knit("Codebook.Rmd", encoding="ISO8859-1")
```

```
## 
## 
## processing file: Codebook.Rmd
```

```
##   |                                                                         |                                                                 |   0%  |                                                                         |....                                                             |   6%
##   ordinary text without R code
## 
##   |                                                                         |........                                                         |  12%
## label: unnamed-chunk-33
##   |                                                                         |...........                                                      |  18%
##   ordinary text without R code
## 
##   |                                                                         |...............                                                  |  24%
## label: unnamed-chunk-34
##   |                                                                         |...................                                              |  29%
##   ordinary text without R code
## 
##   |                                                                         |.......................                                          |  35%
## label: unnamed-chunk-35
##   |                                                                         |...........................                                      |  41%
##   ordinary text without R code
## 
##   |                                                                         |...............................                                  |  47%
## label: unnamed-chunk-36
##   |                                                                         |..................................                               |  53%
##   ordinary text without R code
## 
##   |                                                                         |......................................                           |  59%
## label: unnamed-chunk-37
##   |                                                                         |..........................................                       |  65%
##   ordinary text without R code
## 
##   |                                                                         |..............................................                   |  71%
## label: unnamed-chunk-38
##   |                                                                         |..................................................               |  76%
##   ordinary text without R code
## 
##   |                                                                         |......................................................           |  82%
## label: unnamed-chunk-39
##   |                                                                         |.........................................................        |  88%
##   ordinary text without R code
## 
##   |                                                                         |.............................................................    |  94%
## label: unnamed-chunk-40
##   |                                                                         |.................................................................| 100%
##   ordinary text without R code
```

```
## output file: Codebook.md
```

```
## [1] "Codebook.md"
```

```r
markdownToHTML("Codebook.md", "Codebook.html")
```










