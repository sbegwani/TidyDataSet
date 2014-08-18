## Step 1: Merge the training and test data sets

### Read the test and the training data set
* Obtain the data set for both the test as well as the train data.
* Since all the data is numeric and there are no headers, read.table() can be used with colClasses = "numeric" and header = FALSE
* The code assumes that the test and train folders are in the current working directory

### Read in the features list
* Read the features.txt containing the 561 feature names. 
* These will form the column names of the above two data sets. 
* However, the features data set, when read in, returns two columns. 
* The second column is the vector of names, the first is just a set of serial numbers
* Assign the names to the columns in both the test and train data sets

### Read in activity and subject numbers
* Read the subject variables for both the testing and training data sets.
* We will read the values as characters, instead of integers
* Add subject column to both the test and train data sets
* Read the activity variables for both the testing and training data sets
* We will read the values as characters, instead of integers
* Add activity column to both the data sets

### Merge the two data sets
* This is done using the rbind() command
* The combined data set is called combinedData


## Step 2: Extract only mean() and std() observations

### Approach
* We will extract only those columns which have "mean()" or "std()" in the column headers
* Of course, we need to retain the subjectNumber and activity columns, which are columns 562 and 563 in the combined data set

### Programming Technique
* Get two logical vectors. 
* Logical vector meanPresent returns TRUE for all columns where text "mean()" is present. 
* Logical vector stdPresent  returns TRUE for all columns where text "std()" is present. 
* A logical union (OR) of the two vectors is required. 
* The last two elements in the union vector must be set to TRUE to retain subjectNumber and activity
* The grepl() function along with regular expressions is used to do the matching
* The output is a data set with truncated columns, i.e. only those columns which have "mean()" or "std()" in the column headers plus the subjectNumber and activity columns
* This truncated data set is called extractedData


## Step 3: Provide descriptive activity names

* This is simply replacing numeric values in the activity column with their text equivalent. 
* The file activity_labels.txt provides the number - text mapping


## Step 4: Provide descriptive variable names

* This involves a series of steps to convert the column names into more descriptive names
* It is essentially string manipulation using the gsub() commands together with reasonably complex regular expressions

## Step 5: Summarize the data by activity and subject

* The aggregate() function in R will be used. The first argument is the set of columns to summarize, the second is the grouping columns, and the third argument is the function to apply
* The summarized data is called finalData
* The resulting summarized data set is sorted by activity and, within activity, by subject number. Both sorts are ascending
* The final tidy data is written to a text file finalData.txt using write.table()


===========================================================================