run_analysis<-function(){

# Reading the test and training sets
X_train<-read.table("./FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
X_test<-read.table("./FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")

# Binding the feature vectors
X<-rbind(X_train,X_test)

# Finding the features that either relates to mean or std!
features<-read.table("./FUCI HAR Dataset/UCI HAR Dataset/features.txt")
mean_std_ind<-grep("mean|std",features[,2])
only_mean_std_in_X<-X[,mean_std_ind]
names<-features[mean_std_ind,2]
names<-gsub('-mean','Mean',names)
names<-gsub('-std','Std',names)
names<-gsub('[-()]','',names)
colnames(only_mean_std_in_X)<-names


library(data.table)

# Reading the activity labels
activity_labels<-read.table("./FUCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
y_train<-read.table("./FUCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
y_test<-read.table("./FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

# Reading the subjects
subject_train<-read.table("./FUCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("./FUCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
subject<-rbind(subject_train,subject_test)
names(subject)<-"subject"
# Binidng the activity labels 
y<-rbind(y_train,y_test)
names(y)<-"activity"

# Binding all columns together
subject_activity_mean_std<-cbind(subject,y,only_mean_std_in_X)

# Finding the mean for each subject and each activity
DT<-data.table(subject_activity_mean_std)
Data<- DT[, lapply(.SD, mean), by=c("subject", "activity")]
write.table(Data,"tidy.txt")
}
