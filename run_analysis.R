## Getting & Cleaning Data, Coursera/JHU 
## eyspahn, April 2015
## Course Project
## 
## You should create one R script called run_analysis.R that does the following:
##     
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# #Get, load data
# url<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(url, destfile="projectdataset.zip")
# unzip("projectdataset.zip")
# #unzips to "UCI HAR Dataset" folder

#read data
#assuming we're accessing UCI HAR Dataset folder with unzipped contents
#feature names in features.txt

#the features (tBodyAcc-mean()-X, etc) - 561 x 2  (--> join based on the int #)
features <- read.table("./UCI HAR Dataset/features.txt",
                       stringsAsFactors=FALSE)

#Activity labels: walking, sitting, etc
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",
                            stringsAsFactors=FALSE)

#Each row IDs the subject who performed the activity for each window sample, range from 1-30.
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

#data set: measurements x 561 obsv.
test_data<-read.table("./UCI HAR Dataset/test/x_test.txt")
train_data<-read.table("./UCI HAR Dataset/train/X_train.txt")

#The activity # relating to the activity labels, range 1 - 6; measurements x 1
train_activity<-read.table("./UCI HAR Dataset/train/y_train.txt")
test_activity<-read.table("./UCI HAR Dataset/test/y_test.txt")


# 1. Merges the training and the test sets to create one data set.
#Make sure to put these together in the same order! Test, then train.
data_subject<-rbind(subject_test, subject_train)
names(data_subject)<-c("subjectID")
data_activity<-rbind(test_activity, train_activity)
data_set_i<-rbind(test_data, train_data)

#add the activity numbers
data_set<-cbind(data_set_i, data_activity)
names(data_set)[562]<-"activitynumber"  #rename activity number column

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

#find the feature labels where the data names contain "-mean" or "-std"
mean_meas<-grep("-mean", features[,2])
std_meas<-grep("-std", features[,2])
#combine the rows 
#mean_std_inds<-sort(c(mean_meas, std_meas)

inds<-sort(c(mean_meas,std_meas, 562)) #include 562 to cover the column of activity numbers
#extract the data for mean & std variables & pull it into data_subset
#using "i" to indicate intermediate (non-final) data set
#data_subset_i is the data set containing the activity, means and std data
data_subset_i<-data_set[,inds]


## 3. Uses descriptive activity names to name the activities in the data set
#walking, walking_upstairs, etc
#Add the data_activity code to the data & rename column name
#merge reorders based on the activity lables--need to suppress that

data_subset_ii<-merge(data_subset_i, activity_labels, by.x="activitynumber",
                               by.y="V1", sort=FALSE) 

names(data_subset_ii)[81]<-"activityname"
names(data_subset_ii)[1]<-"activitynumber"

## 4. Appropriately labels the data set with descriptive variable names. 
#"features" contains the descriptive variable names

inds_i<-sort(c(mean_meas,std_meas)) #only mean and std vars

#rename data with names from "feature"
names(data_subset_ii)[2:80]<-features[inds_i,2]


## 5. From the data set in step 4, creates a second, independent tidy data set with
##    the average of each variable for each activity and each subject.

#add in subject info to data
data_subset_iii <-cbind(data_subset_ii, data_subject)

#USe dplyr...
#install.packages("dplyr")
library(dplyr)

data_subset_tbldf<-tbl_df(data_subset_iii)

#delete activity name, because summarise_each turns activity name into Nulls
data_subset_tbldf<-mutate(data_subset_tbldf, activityname=NULL)

grouped_data<-group_by(data_subset_tbldf, activitynumber, subjectID)

summarized_means<-summarise_each(grouped_data, funs(mean))

#add in the activityname back in
summarized_means_ii<-merge(summarized_means, activity_labels, by.x="activitynumber",
                      by.y="V1", sort=FALSE)

names(summarized_means_ii)[82]<-"activityname"

reordered_means<-cbind(summarized_means_ii[1], summarized_means_ii[82],
                       summarized_means[2:81])


write.table(reordered_means, file="means.txt", row.name=FALSE, quote = FALSE,
            sep="\t")

#Also provide codebook.
