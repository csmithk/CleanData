library(dplyr)

getXYSubjectMeanAndStdOnly <- function (x, y, subject, features, activities){
  #give subject useful name
  subject <- rename(subject, subject = V1)
  #give the features column a useful name
  features <- rename(features, description = V2)
  #get rid of useless first column
  features <- select(features, description)
  #extract description column as a vector for column names
  f <- as.vector(features[['description']])
  #set column names for data
  colnames(x) <- f
  #give y useful column name
  
  y <- rename(y, act = V1)
  #add a column that will be used later for sorting back after merge
  y <- cbind(y, order = c(1:(nrow(y))))
  
  #give activities useful names
  activities <- rename(activities, number = V1, activity = V2)
  
  #merge y and activities to get name 
  y <- merge(y, activities, by.x = "act", by.y = "number", all = T)
  #reorder because merge toasts y order
  y <- arrange(y, order)
  #just want the description
  y <- select(y, activity)
  
  #get only the mean and std
  m <- grep("mean", names(x))
  std <- grep("std", names(x))
  colsWeCareAbout <- c(m, std)
  x_MeanStd <- x[,colsWeCareAbout]
  #column bind x and y sets
  xy <- cbind(y, x_MeanStd)
  cbind(subject, xy)
  
}

subject_train <- read.table("subject_train.txt", sep = " ", header = F)
x_train <- read.table("X_train.txt", header = F) 
y_train <- read.table("y_train.txt", header = F)
features <- read.table("features.txt", header = F)
activities <- read.table("activity_labels.txt", header = F)

subject_test <- read.table("subject_test.txt", sep = " ", header = F)
x_test <- read.table("X_test.txt", header = F) 
y_test <- read.table("y_test.txt", header = F)

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

myData <- getXYSubjectMeanAndStdOnly(x, y, subject, features, activities)

f <- c(
  "Subject",
  "Activity",
  "MeanOfTBodyAccMeanY",
  "MeanOfTBodyAccMeanZ",
  "MeanOfTGravityAccMeanX",
  "MeanOfTGravityAccMeanY",
  "MeanOfTGravityAccMeanZ",
  "MeanOfTBodyAccJerkMeanX",
  "MeanOfTBodyAccJerkMeanY",
  "MeanOfTBodyAccJerkMeanZ",
  "MeanOfTBodyGyroMeanX",
  "MeanOfTBodyGyroMeanY",
  "MeanOfTBodyGyroMeanZ",
  "MeanOfTBodyGyroJerkMeanX",
  "MeanOfTBodyGyroJerkMeanY",
  "MeanOfTBodyGyroJerkMeanZ",
  "MeanOfTBodyAccMagMean",
  "MeanOfTGravityAccMagMean",
  "MeanOfTBodyAccJerkMagMean",
  "MeanOfTBodyGyroMagMean",
  "MeanOfTBodyGyroJerkMagMean",
  "MeanOfFBodyAccMeanX",
  "MeanOfFBodyAccMeanY",
  "MeanOfFBodyAccMeanZ",
  "MeanOfFBodyAccMeanFreqX",
  "MeanOfFBodyAccMeanFreqY",
  "MeanOfFBodyAccMeanFreqZ",
  "MeanOfFBodyAccJerkMeanX",
  "MeanOfFBodyAccJerkMeanY",
  "MeanOfFBodyAccJerkMeanZ",
  "MeanOfFBodyAccJerkMeanFreqX",
  "MeanOfFBodyAccJerkMeanFreqY",
  "MeanOfFBodyAccJerkMeanFreqZ",
  "MeanOfFBodyGyroMeanX",
  "MeanOfFBodyGyroMeanY",
  "MeanOfFBodyGyroMeanZ",
  "MeanOfFBodyGyroMeanFreqX",
  "MeanOfFBodyGyroMeanFreqY",
  "MeanOfFBodyGyroMeanFreqZ",
  "MeanOfFBodyAccMagMean",
  "MeanOfFBodyAccMagMeanFreq",
  "MeanOfFBodyBodyAccJerkMagMean",
  "MeanOfFBodyBodyAccJerkMagMeanFreq",
  "MeanOfFBodyBodyGyroMagMean",
  "MeanOfFBodyBodyGyroMagMeanFreq",
  "MeanOfFBodyBodyGyroJerkMagMean",
  "MeanOfFBodyBodyGyroJerkMagMeanFreq",
  "MeanOfTBodyAccStdX",
  "MeanOfTBodyAccStdY",
  "MeanOfTBodyAccStdZ",
  "MeanOfTGravityAccStdX",
  "MeanOfTGravityAccStdY",
  "MeanOfTGravityAccStdZ",
  "MeanOfTBodyAccJerkStdX",
  "MeanOfTBodyAccJerkStdY",
  "MeanOfTBodyAccJerkStdZ",
  "MeanOfTBodyGyroStdX",
  "MeanOfTBodyGyroStdY",
  "MeanOfTBodyGyroStdZ",
  "MeanOfTBodyGyroJerkStdX",
  "MeanOfTBodyGyroJerkStdY",
  "MeanOfTBodyGyroJerkStdZ",
  "MeanOfTBodyAccMagStd",
  "MeanOfTGravityAccMagStd",
  "MeanOfTBodyAccJerkMagStd",
  "MeanOfTBodyGyroMagStd",
  "MeanOfTBodyGyroJerkMagStd",
  "MeanOfFBodyAccStdX",
  "MeanOfFBodyAccStdY",
  "MeanOfFBodyAccStdZ",
  "MeanOfFBodyAccJerkStdX",
  "MeanOfFBodyAccJerkStdY",
  "MeanOfTBodyAccMeanX",
  "MeanOfFBodyAccJerkStdZ",
  "MeanOfFBodyGyroStdX",
  "MeanOfFBodyGyroStdY",
  "MeanOfFBodyGyroStdZ",
  "MeanOfFBodyAccMagStd",
  "MeanOfFBodyBodyAccJerkMagStd",
  "MeanOfFBodyBodyGyroMagStd",
  "MeanOfFBodyBodyGyroJerkMagStd"
)

colnames(myData) <- f

group <- group_by(myData, Subject, Activity)

summary <- summarize_each(group, funs(mean))

write.table(summary, file = "summaryData.txt")


