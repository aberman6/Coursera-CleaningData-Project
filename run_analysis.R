install.packages("dplyr")
library(dplyr)

#get zip file
setwd("/Users/annaberman/Desktop/datasciencecoursera/3CleaningData")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file <- "./Assignment.zip"
if(!file.exists(file)){
  print("getting data")
  download.file(fileUrl, destfile = file, method = "curl")
}

#unzip files
datafolder <- "UCI HAR Dataset"
resultsfolder <- "results"
if(!file.exists(datafolder)){
  print("unzip file")
  unzip("Assignment.zip", list = FALSE, overwrite = TRUE)
}

#download keys
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
colnames(activity_labels)  = c('activityID','activity');

#download test data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
colnames(subject_test) <- "subjectID"
colnames(y_test) <- "activityID";
colnames(x_test) <- features[,2]; 

#download training data
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
colnames(subject_train) <- "subjectID"
colnames(y_train) <- "activityID";
colnames(x_train) <- features[,2]; 

#merge test and train datasets
testData <- cbind(subject_test, y_test, x_test)
trainData <- cbind(subject_train, y_train, x_train)

#create variable for test or train
#testData[,564] <- "test"
#trainData[,564] <- "train"
#testData <- rename(testData, test_train = V564)
#trainData <- rename(trainData, test_train = V564)

#merge into single dataset
allData <- rbind(testData, trainData)
colNames <- colnames(allData)

#create logical vector for column names containing: subjectID, activityID, mean, or std
#finalCol <- grepl("subjectID|(.*)[Mm]ean(.*)|(.*)std(.*)|(.*)activity(.*)|test_train", colNames)
finalCol <- grepl("subjectID|(.*)[Mm]ean(.*)|(.*)std(.*)|(.*)activity(.*)", colNames)

#use logical vector to create dataset with only mean and std variables
finalData <- allData[, finalCol]

#replace activityID with activity type
finalData <- merge(finalData, activity_labels,by='activityID',all.x=TRUE)
finalColNamesEdited <- colnames(finalData)

#edit column names
for (i in 1:length(finalColNamesEdited)) 
{
  finalColNamesEdited[i] <- gsub("\\()","",finalColNamesEdited[i])
  finalColNamesEdited[i] <- gsub("std","StdDev",finalColNamesEdited[i])
  finalColNamesEdited[i] <- gsub("mean","Mean",finalColNamesEdited[i])
  finalColNamesEdited[i] <- gsub("^(t)","time",finalColNamesEdited[i])
  finalColNamesEdited[i] <- gsub("tBody","TimeBody",finalColNamesEdited[i])
  finalColNamesEdited[i] <- gsub("^(f)","freq",finalColNamesEdited[i])
  finalColNamesEdited[i] <- gsub("([Gg]ravity)","Gravity",finalColNamesEdited[i])
  finalColNamesEdited[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",finalColNamesEdited[i])
  finalColNamesEdited[i] <- gsub("[Gg]yro","Gyro",finalColNamesEdited[i])
  finalColNamesEdited[i] <- gsub("[Aa]cc","Acc",finalColNamesEdited[i])
  #finalColNamesEdited[i] = gsub("timeest_train","testOrTrain",finalColNamesEdited[i])
}

#rename columns with edited names
colnames(finalData) <- finalColNamesEdited

#final dataset with no activity type
finalDataNoAct <- finalData[,names(finalData) != 'activity']

#summarize finalDataNoAct to include just the mean of each variable for each activity and each subject
tidyData <- aggregate(finalDataNoAct[,names(finalDataNoAct) != c('activityID','subjectID')],by=list(activityID=finalDataNoAct$activityID,subjectID = finalDataNoAct$subjectID),mean)

#include descriptive activity names
tidyData <- merge(tidyData,activity_labels,by='activityID',all.x=TRUE)

#export tidyData
write.table(tidyData, './tidyData.txt',row.names=FALSE,sep='\t')
