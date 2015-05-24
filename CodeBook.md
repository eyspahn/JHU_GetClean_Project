The script "run_analysis.r" performs the following:

 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive variable names. 
 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

 The original data is in the folder "UCI HAR Dataset," which is available from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
 There is a readme file in the folder which describes the variables.

 Most of the variables should be well-described in comments. Important variables:
 
data_set			 Combined data set containing both test and training data. Result for step 1.

data_subset_i		The combined data set including the activity, mean and standard deviation data. Result for step 2.

data_subset_ii		The combined data set in data_subset_i, with descriptive labels. Result for step 3, 4.

inds_i				Indicies indicating rows containing mean and standard variables in the original data set

data_subset_iii		Adds in subject information to data_subset_ii.	

summarized_means	Create means based on grouped data

summarized_means_ii	Add label for activity name to means

reordered_means		This is the final tidy data set, as described in step 5.
