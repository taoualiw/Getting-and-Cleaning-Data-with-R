#CodeBook
##Description
Additional information that describes the variables, the data, and any transformations or work  performed to clean up the data.
## Where to find the original data  set?

        -Files URL : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
        -Description URL: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
        
## What is the original dataset about ?
The dataset contains raw and preprocessed body movement information from experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) and his 3-axial linear acceleration and 3-axial angular velocity were captured using a smartphone (Samsung Galaxy S II) weared on the waist. 

## Which files from the original dataset were used in our transformation code?

        -'features.txt': List of all features.
        -'activity_labels.txt': Links the class labels with their activity name.
        -'X_train.txt': Training set.
        -'y_train.txt': Training labels.
        -'X_test.txt': Test set.
        -'y_test.txt': Test labels.
        -'subject_train.txt': Each row identifies the subject who performed the activity
        -'subject_test.txt': Each row identifies the subject who performed the activity 
## What transformations have we applied to the dataset?

        - Merging the training and the test sets to create one data set.
        - Extracting only the measurements on the mean and standard deviation for each measurement.
        - Separate columns corresponding to multiple variables
        - Using descriptive activity names to name the activities in the data set
        - Appropriately labeling the data set with descriptive activity names.
        - Creating a second, independent tidy data set with the average of each variable for each activity and each subject.
        
## What are the variables in the new data set ?

### New dataset file: "new_tidy_df.csv"

### Variables description:

    1-*subjecRef*: volunteer id, [integer], ranges between 1 and 30
    2-*activity*: experimental task label, [char (string)], could be one of the following
    activities: "LAYING","SITTING","STANDING","WALKING","WALKING_DOWNSTAIRS","WALKING_UPSTAIRS"
    3-*domain*:defines the calculation domain, [char], could be "time" or "frequency"
    4-*system*:defines the considered system/frame, [char], could be "body" or "gravity"
    5-*device*:defines the device used for the raw measure, [char], could be "gyroscope" or "accelerometer"
    6-*jerk*:whether the feature measure contains jerk signal calculation , [char], could be "TRUE" or "FALSE"    
    7-*magnitude*: whether the feature measure contains magnitude calculation, [char], could be "TRUE" or "FALSE"
    8-*axis*: specified for 3-axial measures, [char], could be "X","Y","Z" or "FALSE" if no axis is specified
    9-*stats*: the selected features measures , [char], could be "mean" or "standardDeviation"
    10-*average*: the average of each feature (combination of variables 2:9) for each activity and each subject,
        [numeric], rangesbetween -1 and 1

