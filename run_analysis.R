## ***********Step 1: Merge the training and test data sets***********

## Obtain the data set for both the test as well as the train data.
## Since all the data is numeric and there are no headers,
## the parameters to read.table() have been set appropriately
## Here the test and train folders are assumed in the current working
## directory, which can be found by using getwd()

testData <- read.table("./test/X_test.txt",header=FALSE,colClasses="numeric")
trainData <- read.table("./train/X_train.txt",header=FALSE,
                        colClasses = "numeric")


## Read the features header containing the 561 features. These will form
## the column names of the above two data sets. However, the features data
## set, when read in, returns two columns. The second column constitutes
## the names, the first column is just a set of serial numbers

features <- read.table("./features.txt", header=FALSE,colClasses="character")
features <- features[,2] ## Picking up only the second column
                        ## This effectively converts the data frame into a 
                        ## character vector

## Assign column names to ther test and the train data

colnames (testData) <- features
colnames (trainData) <- features

## Read the subject variables for both the testing and training data sets
## We will read the values as characters, instead of integers

subjectDataTest <- read.table("./test/subject_test.txt",header=FALSE,
                              colClasses="character")
subjectDataTrain <- read.table("./train/subject_train.txt", header=FALSE,
                               colClasses="character")

## Add subject column to both the data sets

testData$subjectNumber <- subjectDataTest[[1]]
trainData$subjectNumber <- subjectDataTrain[[1]]

## Read the actvivity variables for both the testing and training data sets
## We will read the values as characters, instead of integers

activityDataTest <- read.table("./test/y_test.txt",header=FALSE,
                               colClasses="character")
activityDataTrain <- read.table("./train/y_train.txt",header=FALSE,
                               colClasses="character")

## Add activity column to both the data sets

testData$activity <- activityDataTest[[1]]
trainData$activity <- activityDataTrain[[1]]

## Merge (combine) the two data sets

combinedData <- rbind(trainData,testData) ## End of step 1




## ***Step 2: Extract only mean() and std() observations***

## We will extract only those columns which have "mean()" or "std()"
## in the column headers
## Of course, we need to retain the subjectNumber and activityNumber
## columns, which are columns 562 and 563 in the combined data set

## Get two logical vectors. Logical vector meanPresent returns TRUE for
## all columns where text "mean()" is present. Logical vector stdPresent 
## returns TRUE for all columns where text "std()" is present. A logical
## union (OR) of the two vectors is required. The last two elements in the 
## union vector must be set to TRUE to retain subjectNumber and
## activityNumber

meanPresent <- grepl("(.*)(mean)(\\()(\\))(.*)", colnames(combinedData))
stdPresent <- grepl("(.*)(std)(\\()(\\))(.*)", colnames(combinedData))
meanOrstd <- meanPresent | stdPresent
meanOrstd[562] <- TRUE
meanOrstd[563] <- TRUE

extractedData <- combinedData[,meanOrstd] ## End of step 2

## ***Step 3: Provide descriptive activity names***


## Note that in the data set, 1 represents Walking, 2 Walking Upstairs, 
## and so on, as defined in the activity_labels.txt file
## Here we create a 6 value vector where the first element is Walking
## second element is Walking Upstairs and so on

activityNames <- c("Walking","Walking Upstairs","Walking Downstairs",
                   "Sitting","Standing","Lying")

matchVector <- as.integer(extractedData[["activity"]])

## For each row, we now need to replace the value of the activity
## column with the corresponding string representation
## as defined in activityNames vector

for (i in 1:nrow(extractedData))
{
  extractedData[["activity"]][i] <- activityNames[matchVector[i]]
}  ## End of Step 3

## ***Step 4: Provide descriptive variable names***

## This will be a series of steps to convert the column
## names into more descriptive names

columnNames <- colnames(extractedData)

## More descriptive names for the axes
columnNames <- gsub("-X"," along the X axis", columnNames)
columnNames <- gsub("-Y"," along the Y axis", columnNames)
columnNames <- gsub("-Z"," along the Z axis", columnNames)

## More descriptive names for the measures
columnNames <- gsub("BodyAccJerk", " Jerk of Body Acceleration ", 
                    columnNames)
columnNames <- gsub("BodyAcc", " Acceleration of Body ", columnNames)
columnNames <- gsub("GravityAcc", " Gravitational Acceleration ", 
                    columnNames)
columnNames <- gsub("BodyGyroJerk", " Jerk of Body Gyration ", columnNames)
columnNames <- gsub("BodyGyro", " Body Gyration ", columnNames)

## More descriptive names for the time and frequency along with 
## aggregation measure
## In the following examples of gsub(), the second parameter or the
## replacement value references the first parameter or the search
## value. For instance \\2 refers to the second expression within
## () in the search string

columnNames <- gsub("^(t)(.*)(-mean)(\\()(\\))(.*)",
                    "Mean of\\2\\6 - time dimension", columnNames)
columnNames <- gsub("^(t)(.*)(-std)(\\()(\\))(.*)",
                    "Standard Deviation of\\2\\6 - time dimension", 
                    columnNames)
columnNames <- gsub("^(f)(.*)(-mean)(\\()(\\))(.*)",
                     "Mean of\\2\\6 - time dimension", columnNames)
columnNames <- gsub("^(f)(.*)(-std)(\\()(\\))(.*)",
                     "Standard Deviation of\\2\\6 - time dimension", 
                     columnNames)

colnames(extractedData) <- columnNames# End of step 4


## At this point, the column names are as descriptive as understood
## The column names, columnNames[61] to columnNames[66] are
## still not as descriptive as they can be. This is because, if we look
## at the features.txt file, there are a few variables of the type
## fBodyBody.... or tBodyBody... what does double use of Body mean
## is not understood and hence has not been changed

## ***Step 5: Summarize the data***

## The aggregate() function in R will be used. The first argument is 
## the columns to summarize, the second is the grouping columns,
## and the third argument is the function to apply

## Total number of columns to be summarized
totalCols <- length(colnames(extractedData))-2

finalData <- aggregate(extractedData[colnames(extractedData)[1:totalCols]],
                       by = extractedData[c("activity","subjectNumber")], 
                       FUN=mean)

finalData$subjectNumber <- as.integer(finalData$subjectNumber)## for
## efficient sorting
finalData <- finalData[order(finalData$activity,finalData$subjectNumber),]
## The above is the final tidy data set


## Write the data to finalData.txt
write.table(finalData,"./finalData.txt", quote=FALSE, row.names=FALSE)

## ******************** THE END *****************************************