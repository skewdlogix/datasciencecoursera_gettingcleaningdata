---
title: "Codebook"
author: "skewdlogix"
date: "March 20, 2017"
output: html_document
---


```r
knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
library(data.table)
setwd("D:/R_workplace/DataScienceSpecialization/getting_and_cleaning_data/data")
```

## List of Variables

The final tidy data set is created in the long form and has the folowing variables:


```r
final_tidy_data <- read.table("HumanActivityRecognitionUsingSmartphones.txt", header= TRUE)
names(final_tidy_data)
```

```
## [1] "Subject"     "Activities"  "Measurement" "Average"
```

## Composition of Each Variable with Description

Subject --  Each observation identifies the subject who performed the activity for each window sample. The number of subjects range from 1 to 30. This variable is a factor.


```r
unique(final_tidy_data[,1])
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
## [24] 24 25 26 27 28 29 30
```

Activities  --  Each subject performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. This variable is a factor.


```r
unique(final_tidy_data[,2])
```

```
## [1] LAYING             SITTING            STANDING          
## [4] WALKING            WALKING_DOWNSTAIRS WALKING_UPSTAIRS  
## 6 Levels: LAYING SITTING STANDING WALKING ... WALKING_UPSTAIRS
```

Measurement --  Each Measurement observation identifies either the mean and standard deviation of a combination of features which include the time and frequency of triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration as well as triaxial angular velocity from the gyroscope. The acceleration signal was separated into body and gravity acceleration signals and the body linear acceleration and angular velocity were derived in time to obtain Jerk signals. Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm. These X, Y, Z hyphenated compounds to some of the observations indicate/denote 3-axial signals in the X, Y and Z directions. A decision was made to not try and break the component factors out since this would have merely increased the number of fields with no gain in explanatory power. In addition, doing so would have generated many NA entries. This variable is a factor.


```r
unique(final_tidy_data[,3])
```

```
##  [1] time_Body_Acceleration-mean()-X                       
##  [2] time_Body_Acceleration-mean()-Y                       
##  [3] time_Body_Acceleration-mean()-Z                       
##  [4] time_Body_Acceleration-std()-X                        
##  [5] time_Body_Acceleration-std()-Y                        
##  [6] time_Body_Acceleration-std()-Z                        
##  [7] time_Gravity_Acceleration-mean()-X                    
##  [8] time_Gravity_Acceleration-mean()-Y                    
##  [9] time_Gravity_Acceleration-mean()-Z                    
## [10] time_Gravity_Acceleration-std()-X                     
## [11] time_Gravity_Acceleration-std()-Y                     
## [12] time_Gravity_Acceleration-std()-Z                     
## [13] time_Body_Acceleration_Jerk-mean()-X                  
## [14] time_Body_Acceleration_Jerk-mean()-Y                  
## [15] time_Body_Acceleration_Jerk-mean()-Z                  
## [16] time_Body_Acceleration_Jerk-std()-X                   
## [17] time_Body_Acceleration_Jerk-std()-Y                   
## [18] time_Body_Acceleration_Jerk-std()-Z                   
## [19] time_Body_Gyroscope-mean()-X                          
## [20] time_Body_Gyroscope-mean()-Y                          
## [21] time_Body_Gyroscope-mean()-Z                          
## [22] time_Body_Gyroscope-std()-X                           
## [23] time_Body_Gyroscope-std()-Y                           
## [24] time_Body_Gyroscope-std()-Z                           
## [25] time_Body_Gyroscope_Jerk-mean()-X                     
## [26] time_Body_Gyroscope_Jerk-mean()-Y                     
## [27] time_Body_Gyroscope_Jerk-mean()-Z                     
## [28] time_Body_Gyroscope_Jerk-std()-X                      
## [29] time_Body_Gyroscope_Jerk-std()-Y                      
## [30] time_Body_Gyroscope_Jerk-std()-Z                      
## [31] time_Body_Acceleration_Magnitude-mean()               
## [32] time_Body_Acceleration_Magnitude-std()                
## [33] time_Gravity_Acceleration_Magnitude-mean()            
## [34] time_Gravity_Acceleration_Magnitude-std()             
## [35] time_Body_Acceleration_Jerk_Magnitude-mean()          
## [36] time_Body_Acceleration_Jerk_Magnitude-std()           
## [37] time_Body_Gyroscope_Magnitude-mean()                  
## [38] time_Body_Gyroscope_Magnitude-std()                   
## [39] time_Body_Gyroscope_Jerk_Magnitude-mean()             
## [40] time_Body_Gyroscope_Jerk_Magnitude-std()              
## [41] frequency_Body_Acceleration-mean()-X                  
## [42] frequency_Body_Acceleration-mean()-Y                  
## [43] frequency_Body_Acceleration-mean()-Z                  
## [44] frequency_Body_Acceleration-std()-X                   
## [45] frequency_Body_Acceleration-std()-Y                   
## [46] frequency_Body_Acceleration-std()-Z                   
## [47] frequency_Body_Acceleration_Jerk-mean()-X             
## [48] frequency_Body_Acceleration_Jerk-mean()-Y             
## [49] frequency_Body_Acceleration_Jerk-mean()-Z             
## [50] frequency_Body_Acceleration_Jerk-std()-X              
## [51] frequency_Body_Acceleration_Jerk-std()-Y              
## [52] frequency_Body_Acceleration_Jerk-std()-Z              
## [53] frequency_Body_Gyroscope-mean()-X                     
## [54] frequency_Body_Gyroscope-mean()-Y                     
## [55] frequency_Body_Gyroscope-mean()-Z                     
## [56] frequency_Body_Gyroscope-std()-X                      
## [57] frequency_Body_Gyroscope-std()-Y                      
## [58] frequency_Body_Gyroscope-std()-Z                      
## [59] frequency_Body_Acceleration_Magnitude-mean()          
## [60] frequency_Body_Acceleration_Magnitude-std()           
## [61] frequency_Body_Body_Acceleration_Jerk_Magnitude-mean()
## [62] frequency_Body_Body_Acceleration_Jerk_Magnitude-std() 
## [63] frequency_Body_Body_Gyroscope_Magnitude-mean()        
## [64] frequency_Body_Body_Gyroscope_Magnitude-std()         
## [65] frequency_Body_Body_Gyroscope_Jerk_Magnitude-mean()   
## [66] frequency_Body_Body_Gyroscope_Jerk_Magnitude-std()    
## 66 Levels: frequency_Body_Acceleration-mean()-X ...
```

Average -- This variable contains the averages of the mean and standard deviation for each measurement type calculated across all unique combinations of subjects and activities. This variable is a calculated average measurement observation which is unique to each combination of factors.

## Structure of the Tidy Dataset


```r
str(final_tidy_data)
```

```
## 'data.frame':	11880 obs. of  4 variables:
##  $ Subject    : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Activities : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ Measurement: Factor w/ 66 levels "frequency_Body_Acceleration-mean()-X",..: 27 28 29 30 31 32 59 60 61 62 ...
##  $ Average    : num  0.2216 -0.0405 -0.1132 -0.9281 -0.8368 ...
```

```r
dim(final_tidy_data)
```

```
## [1] 11880     4
```

## Summary of the Tidy Dataset


```r
summary(final_tidy_data)
```

```
##     Subject                  Activities  
##  Min.   : 1.0   LAYING            :1980  
##  1st Qu.: 8.0   SITTING           :1980  
##  Median :15.5   STANDING          :1980  
##  Mean   :15.5   WALKING           :1980  
##  3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980  
##  Max.   :30.0   WALKING_UPSTAIRS  :1980  
##                                          
##                                Measurement       Average        
##  frequency_Body_Acceleration-mean()-X:  180   Min.   :-0.99767  
##  frequency_Body_Acceleration-mean()-Y:  180   1st Qu.:-0.96205  
##  frequency_Body_Acceleration-mean()-Z:  180   Median :-0.46989  
##  frequency_Body_Acceleration-std()-X :  180   Mean   :-0.48436  
##  frequency_Body_Acceleration-std()-Y :  180   3rd Qu.:-0.07836  
##  frequency_Body_Acceleration-std()-Z :  180   Max.   : 0.97451  
##  (Other)                             :10800
```

## The Tidy Dataset (the first 30 rows)


```r
head(final_tidy_data, n= 30)
```

```
##    Subject Activities                          Measurement      Average
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
## 16       1     LAYING  time_Body_Acceleration_Jerk-std()-X -0.958482112
## 17       1     LAYING  time_Body_Acceleration_Jerk-std()-Y -0.924149274
## 18       1     LAYING  time_Body_Acceleration_Jerk-std()-Z -0.954855111
## 19       1     LAYING         time_Body_Gyroscope-mean()-X -0.016553094
## 20       1     LAYING         time_Body_Gyroscope-mean()-Y -0.064486124
## 21       1     LAYING         time_Body_Gyroscope-mean()-Z  0.148689436
## 22       1     LAYING          time_Body_Gyroscope-std()-X -0.873543868
## 23       1     LAYING          time_Body_Gyroscope-std()-Y -0.951090440
## 24       1     LAYING          time_Body_Gyroscope-std()-Z -0.908284663
## 25       1     LAYING    time_Body_Gyroscope_Jerk-mean()-X -0.107270949
## 26       1     LAYING    time_Body_Gyroscope_Jerk-mean()-Y -0.041517287
## 27       1     LAYING    time_Body_Gyroscope_Jerk-mean()-Z -0.074050121
## 28       1     LAYING     time_Body_Gyroscope_Jerk-std()-X -0.918608521
## 29       1     LAYING     time_Body_Gyroscope_Jerk-std()-Y -0.967907244
## 30       1     LAYING     time_Body_Gyroscope_Jerk-std()-Z -0.957790160
```

