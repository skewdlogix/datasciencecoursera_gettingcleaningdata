# datasciencecoursera_gettingcleaningdata

# Peer graded assignment for Getting and Cleaning Data - Coursera Data Science Specialization

## Introduction

This file provides a guide on how to implement the R code in run_analysis.R which contains a step-by-step process whereby the initial data files are combined and transposed into a long form tidy data set

## Purpose

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.  The required submissions are: 1) a tidy data set as described below, 2) a link to a Github repository with a script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that were performed to clean up the data called CodeBook.md. In addition, a README.md should also be included in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Assignment Deliverables

There is an R script called run_analysis.R that does the following.

   1) Merges the training and the test sets to create one data set.
   2) Extracts only the measurements on the mean and standard deviation for each measurement.
   3) Uses descriptive activity names to name the activities in the data set
   4) Appropriately labels the data set with descriptive variable names.
   5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
   
## Methodology to Generate Output Files
 
All of the code is contained in 3 files - run_anlysis.R, run_analysis.Rmd, Codebook.Rmd - which are executed when the main file - run_analysis.R - is run.
 
In order to run the file as it exists in the repository, the working directory stated at the beginning of the three files needs to be adjusted so that it reflects the environment where the files reside. In order to accomplish this task, the files will need to be opened with a text editor and the required changes made.

Once the working directories have been adjusted then the R script - run_analysis.R - must be run. As it executes, it will call - run_analysis.RMD - which will then execute and then call - Codebook.Rmd - which will then execute as well.

## Output Files Generated
 
 The scripts will generate a total of five additional files: - run_analysis.md, run_analysis.html, Codebook.md, Codebook.html - and the final tidy data file - HumanActivityRecognitionUsingSmartphones.txt.
 
 The final tidy data file is in the long form of a narrow data table with Subject and Activities in the first two columns and the types of measurement for each Subject and Activities combination in the next column and the resulting value of the measurements in the final column.   
This is the long form of tidy data as mentioned in the rubric as either long or wide form is acceptable.
