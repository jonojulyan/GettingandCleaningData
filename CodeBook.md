# Code Book
## Methods
* extractActivityLabels - Gets the data for the activity labels
* extractFeatures - Gets the fature names for the mean and std features.
* mergeSets - Merges the training and testing data sets. Joins the activity labels with the data and selects the revavent features. 
* createDataSet - Gets the average of each column grouped by subject and activity. Creates the tidy data set from this.
* splitData - used by other functions for specific data split

## Transformations
### extractActivityLabels
* Data read in from "activity_labels.txt" 
* Data split by space separator

### extractFeatures
* Data read in from "features.txt"
* Data split by space separator
* Take only rows where column two contains std() or mean()
* Split column two by "-"
* Remove any rows where meanFreq() is obtained
* Join the feature names back separated by "-"
* Order the columns by column number

### mergeSets
* Data read in from "y_train.txt", "y_test.txt" for class labels
* Data read in from "X_train.txt", "X_test.txt" for data sets
* Data read in from "subject_train.txt", "subject_test.txt" for subject code
* Data bound together by column for 'class labels', 'subject code' and 'data sets' and by row for training and testing data
* Data merged with extractActivityLabels on 'class labels' to get the activity name
* Only the features from extractFeatures are taken

### createDataSet
* Data from mergeSets averaged for each column grouped by activity name and subject
* Data written to tidy data set