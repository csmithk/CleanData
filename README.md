# CleanData
My R file initially reads in the data:
subject_train.txt - has the subject ids
x_train.txt - training data for X
y_train.txt - training data for Y
features.txt - names of the columns
activities.txt - contains the number and string representation of the activies
x_test.txt - testing data for X
y_test.txt - testing data for Y

The subject data for test and training is combined with rbind()
The x data is created by rbind with the x_train and x_test data.
The y data is created by rbind with the y_train and y_test.

These variables are passed to the function, getXYSubjectMeanAndStdOnly  (x, y, subject, features, activities)
that

gives meaningful names to columns in the data sets (subject, features, activities, y and sets column names for the X data based on the features.txt read in
adds a column to Y called order, it will be needed after merging to preserve the Y order.  This is just a column of 1: nrow(y) so that it can be put back into the correct order.
merges Y with activities to map to string representation
re-order Y with arrange and the order column to put back into the correct order and then select on the name so now Y is a list of activity names instead of the numeric representation
gets the mean and std columns using grep and then extracts only the columns of interest with x[,colsWeCareAbout]
uses cbind to bind the y and x_MeanStd (the X with only the mean and std columns)
In this way, I have created the "long" dataset as stated in the instructions that adheres to the Tidy Data principles.

After returning the tall dataset, I create a character vector of meaningful names for the summary data that will be created.  Initially, I was reading from the code book, but realized that without the code book, this wouldn't run correctly, so hard coded it in the file to ensure the meaningful column names were available.
This character vector is used to set the column names of the tall dataset.
Group_by is used to group the dataset by Subject and Activity
summarize_each is used to calculate the means for all the columns, grouped by Subject and Activity.
The resulting tidy data set is written to summaryData.txt
