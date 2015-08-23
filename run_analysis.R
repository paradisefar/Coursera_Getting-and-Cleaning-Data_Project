#merge training and test data set on each raw data table
feature_data=rbind(read.table("UCI HAR Dataset\\train\\X_train.txt"), read.table("UCI HAR Dataset\\test\\X_test.txt"))
subjectid_data=rbind(read.table("UCI HAR Dataset\\train\\subject_train.txt"), read.table("UCI HAR Dataset\\test\\subject_test.txt"))
label_data=rbind(read.table("UCI HAR Dataset\\train\\y_train.txt"), read.table("UCI HAR Dataset\\test\\y_test.txt"))
activity_labels=read.table("UCI HAR Dataset\\activity_labels.txt")
features=read.table("UCI HAR Dataset\\features.txt")
mean_std_col=sort(unique(c(grep("mean()", features[,2]), grep("std()", features[,2]))))

#extract only the measurements on the mean and standard deviation for each measurement. 
feature_data_tidy=feature_data[, mean_std_col]
#Appropriately labels the data set with descriptive variable names.
names(feature_data_tidy)=features[mean_std_col,2]

#final tidy data
feature_data_tidy$Activity=merge(label_data, activity_labels)[,2]
feature_data_tidy$Subject=subjectid_data[,1]

#independent tidy data set with the average of each variable for each activity and each subject.
summary_tidy=aggregate(feature_data_tidy, by=list(feature_data_tidy$Subject, feature_data_tidy$Activity), FUN=mean)
summary_tidy$Activity <- NULL
summary_tidy$Subject <- NULL
names(summary_tidy)[names(summary_tidy) == 'Group.1'] <- 'Subject'
names(summary_tidy)[names(summary_tidy) == 'Group.2'] <- 'Activity'

write.table(summary_tidy, "summary_tidy.txt", sep="\t", row.names = FALSE)
