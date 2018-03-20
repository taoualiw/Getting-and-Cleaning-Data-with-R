#------------------------------------------------------------------------------------------------
#point 0: Download and Read data set
#-------------------------------------------------------------------------------------------------
library(data.table)
library(dplyr)
library(tidyr)
library(reshape2)
## Verify existence or Download data folder
if(!file.exists("UCI HAR Dataset")){
        if(!file.exists("UCIdata.zip")){
                file_url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                download.file(file_url,"UCIdata.zip", mode = "wb") 
        }
        unzip("UCIdata.zip", files = NULL, exdir=".")
}else {print("Existing folder ")}
# get all files names in the dataset folder
filenames <- list.files("UCI HAR Dataset/", pattern="*.txt", recursive = TRUE)
filenames <- paste("UCI HAR Dataset/", filenames[!filenames%in%c("features_info.txt", "README.txt")], sep="")
# load all files into a liste of datatables
list_df <- lapply(filenames, read.table)
# attribute file names to datables
varnames <- lapply(strsplit(filenames,"/"),function(x)x[length(x)])
varnames <- lapply(varnames,function(x)substr(x,1,(nchar(x)-4)))
names(list_df)<-varnames
#------------------------------------------------------------------------------------------------
#point 4: Appropriately label the data set with descriptive variable names
#-------------------------------------------------------------------------------------------------
# Change df names for activity label from files "y_train","y_test
names(list_df[["y_train"]])<-"activity"
names(list_df[["y_test"]])<-"activity"
# Change column names for features measures from files "X_train","X_test
names(list_df[["X_test"]])<-list_df[["features"]]$V2
names(list_df[["X_train"]])<-list_df[["features"]]$V2
# Change df names for subject reference from files "subject_test","subject_train"
names(list_df[["subject_test"]])<-"subjectRef"
names(list_df[["subject_train"]])<-"subjectRef"
#-----------------------------------------------------------------------
#point 1: Merge the training and the test sets to create one data set
#-----------------------------------------------------------------------
# Merge test datasets
df_test<-cbind(list_df[["subject_test"]],list_df[["y_test"]],list_df[["X_test"]])
# Merge train datasets
df_train<-cbind(list_df[["subject_train"]],list_df[["y_train"]],list_df[["X_train"]])
# Merge test and train datasets 
df_merged <-rbind(df_test,df_train)
#------------------------------------------------------------------------------------------------
#point 2: Extract only the measurements on the mean and standard deviation for each measurement
#-------------------------------------------------------------------------------------------------
# find col names containg "mean()" or "std()"
mean_std_colnames <-names(df_merged)[grepl("mean\\(\\)", names(df_merged)) | grepl("std\\(\\)", names(df_merged))]
# substract data with only mean and std for each measure
new_df_merged <- df_merged[,names(df_merged) %in% c("subjectRef","activity",mean_std_colnames)]
#------------------------------------------------------------------------------------------------
#point 3: Uses descriptive activity names to name the activities in the data set
#-------------------------------------------------------------------------------------------------
new_df_merged$activity<-as.character(list_df[["activity_labels"]][match(new_df_merged$activity,  
                                                                        list_df[["activity_labels"]]$V1), 'V2']) 
#------------------------------------------------------------------------------------
##Clean and Specify column names to account for the fact that more than one variable per column
#-------------------------------------------------------------------------------
names(new_df_merged)<-oldnames
names(new_df_merged)<-gsub("mean\\(\\)", "avg", names(new_df_merged))
names(new_df_merged)<-gsub("std\\(\\)", "std", names(new_df_merged))
#--------
names(new_df_merged)<-gsub("^t", "time.", names(new_df_merged))
names(new_df_merged)<-gsub("^f", "freq.", names(new_df_merged))
#--------
names(new_df_merged)<-gsub("Acc", "Acce.", names(new_df_merged))
names(new_df_merged)<-gsub("Gyro", "Gyro.", names(new_df_merged))
#--------
names(new_df_merged)<-gsub("BodyBody", "Body.", names(new_df_merged))
names(new_df_merged)<-gsub("Body", "Body.", names(new_df_merged))
names(new_df_merged)<-gsub("Gravity", "Grav.", names(new_df_merged))
#---------
names(new_df_merged)<-gsub("Mag", "Magn.", names(new_df_merged))
#---------
names(new_df_merged)<-gsub("Jerk", "Jerk.", names(new_df_merged))
#---------
names(new_df_merged)<-gsub("-avg-X", "Xdim.avg", names(new_df_merged))
names(new_df_merged)<-gsub("-avg-Y", "Ydim.avg", names(new_df_merged))
names(new_df_merged)<-gsub("-avg-Z", "Zdim.avg", names(new_df_merged))
names(new_df_merged)<-gsub("-std-X", "Xdim.std", names(new_df_merged))
names(new_df_merged)<-gsub("-std-Y", "Ydim.std", names(new_df_merged))
names(new_df_merged)<-gsub("-std-Z", "Zdim.std", names(new_df_merged))
names(new_df_merged)<-gsub("-", "\\.", names(new_df_merged))
names(new_df_merged)<-gsub("\\.\\.", "\\.", names(new_df_merged))
#---add Naaa indicating non axial variables names
names(new_df_merged)<-lapply(names(new_df_merged),function(x)if(!substring(x,nchar(x)-7,nchar(x)-4)%in%c("Xdim","Ydim","Zdim")){
if (x%in% c("subjectRef","activity"))x<-x
else x<-paste(substring(x,1,nchar(x)-4),".Naaa",substring(x,nchar(x)-3,nchar(x)),sep="")   
}else{x<-x}
)
#---add Naaa indicating  variables names without magnitude measure
names(new_df_merged)<-lapply(names(new_df_merged),function(x)if(!substring(x,nchar(x)-12,nchar(x)-9)=="Magn"){
        if (x%in% c("subjectRef","activity"))x<-x
        else x<-paste(substring(x,1,nchar(x)-9),".Naaa",substring(x,nchar(x)-8,nchar(x)),sep="")   
}else{x<-x}
)
#---add Naaa indicating  variables names without jerk measure
names(new_df_merged)<-lapply(names(new_df_merged),function(x)if(!substring(x,nchar(x)-17,nchar(x)-14)=="Jerk"){
        if (x%in% c("subjectRef","activity"))x<-x
        else x<-paste(substring(x,1,nchar(x)-14),".Naaa",substring(x,nchar(x)-13,nchar(x)),sep="")   
}else{x<-x}
)
#------------------------------------------------------------------------------------
##Separate columns containing multiple variables
#-------------------------------------------------------------------------------
new_df_merged <- melt(new_df_merged, id.vars = c("subjectRef", "activity"), value.name = "featureValues", variable.name = "domain_system_device_jerk_magnitude_axis_stats")
new_df_merged<-tbl_df(new_df_merged)
new_df_merged <- separate(new_df_merged, domain_system_device_jerk_magnitude_axis_stats, c("domain","system","device","jerk","magnitude","axis","stats"))
#------------------------------------------------------------------------------------
#point 4-bis: Appropriately label the data set with descriptive variable names
#-------------------------------------------------------------------------------
new_df_merged[new_df_merged=="Acce"]="accelerometer"
new_df_merged[new_df_merged=="Gyro"]="gyroscope"
new_df_merged[new_df_merged=="Naaa"]="FALSE"
new_df_merged[new_df_merged=="avg"]="mean"
new_df_merged[new_df_merged=="std"]="standardDeviation"
new_df_merged[new_df_merged=="Magn"]="TRUE"
new_df_merged[new_df_merged=="Jerk"]="TRUE"
new_df_merged[new_df_merged=="Grav"]="gravity"
new_df_merged[new_df_merged=="freq"]="frequency"
new_df_merged[new_df_merged=="Xdim"]="X"
new_df_merged[new_df_merged=="Ydim"]="Y"
new_df_merged[new_df_merged=="Zdim"]="Z"

#------------------------------------------------------------------------------------------------
#point 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject.
#-------------------------------------------------------------------------------------------------
tidy_data <- group_by(new_df_merged,subjectRef,activity,domain,system,device,jerk,magnitude,axis,stats)
tidy_data<- summarize(tidy_data, average = mean(featureValues))
# save dataset
write.csv(tidy_data, "tidy_data.csv")
head(tidy_data)