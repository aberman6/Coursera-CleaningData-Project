# GettingCleaningDataCourseProject
Anna Berman

#Overview
This repo contains my submission for the course project for the Getting and Cleaning Data course by John Hopkins University through Coursera. This project demonstrates my ability to download and prepare a complex dataset for later analysis. 

Full description of the data used in this project can be found at The UCI Machine Learning Repository: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The source data for this project can be found here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#Script Summary
run_analysis.R: downloads a zip file containing multiple datasets and merges them into a single dataset that is ready for analysis. The resulting dataset contains the averages of movement vector means/standard devations preformed by subjects during 6 different activities. This code is the only script involved in this analysis. For more information about what the code entails, please see the codebook for this repo.

*Before you begin: Line 5 of run_analysis.R sets the working directory to my personal computer. To run this code on another computer, please fill in the alternative environment in Line 5.
