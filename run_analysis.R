library(dplyr)

# read all the feature names, we'll use that to label columns
featureNames <- read.table("./features.txt", header=FALSE, sep="", col.names = c("i", "name"))
featureNames$name <- gsub("[-,()]","", featureNames$name)
meanStdCols <- featureNames$name[which(grepl("mean|std", featureNames$name))]

# activity labels
activityLabels <-  read.table("./activity_labels.txt", header=FALSE, sep="", col.names = c("i", "name"))

# performs bulk of the loading and joinging operations
loadData <- function (type) {
  
  # read both training and test datasets, label the columns using feature names
  measurements <- read.table(sprintf("./%s/X_%s.txt",type,type), header=FALSE, sep="", col.names=featureNames$name)
  
  # get the subjects associated with each measurement
  subject <- read.table(sprintf("./%s/subject_%s.txt",type,type), header=FALSE, sep="", col.names=c("Subject"))
  
  # get the activities associated with the measurements
  activities <- read.table(sprintf("./%s/Y_%s.txt",type,type), header=FALSE, sep="", col.names=c("Activity"))
  
  # label all the activities
  activities$ActivityLabels <- factor(activities$Activity, levels = activityLabels$i, labels = activityLabels$name)
  
  # add activities and subjects into the records table
  d <- bind_cols(measurements, activities, subject)
  
  # convert to tibble data frame and downselect only the mean/std, activity, and subject
  d <- tbl_df(d)
  select(d, meanStdCols, Activity, ActivityLabels, Subject)
}

# load both test and training dataset
trainingSet <- loadData("train")
testSet <- loadData("test")

# combine both test and training cases
allMeasurements <- bind_rows(trainingSet, testSet, id=NULL)

# split the data into each activity and subject then compute average
summaryByActivity <- allMeasurements %>% group_by(Subject, ActivityLabels) %>% summarize_all(mean)

# output summary to a file
print(summaryByActivity)
write.table(summaryByActivity, "analysis_output.txt", row.name=FALSE)

