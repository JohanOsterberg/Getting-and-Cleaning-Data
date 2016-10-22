# Load required packages
library(dplyr)
library(data.table)
library(Hmisc)

# Download compressed data file for project and unzip files
FileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(FileUrl,destfile = "Dataset.zip" )
unzip("Dataset.zip",exdir = ".")

# Set working directory to directory created by unzip
setwd(".\\UCI HAR Dataset")

# Read files into data tables
YTrain <- fread("./train/y_train.txt",header = FALSE)
XTrain <- fread("./train/x_train.txt",header = FALSE)
SubjectTrain <- fread("./train/subject_train.txt",header = FALSE)
YTest <- fread("./test/y_test.txt",header = FALSE)
XTest <- fread("./test/x_test.txt",header = FALSE)
SubjectTest <- fread("./test/subject_test.txt",header = FALSE)
Features <- fread("features.txt",header = FALSE)
ActivityLabels <- fread("activity_labels.txt",header = FALSE)

# Merge test and train data tables
Y <- rbind(YTrain,YTest)
X <- rbind(XTrain,XTest)
Subject <- rbind(SubjectTrain,SubjectTest)

# Select features containing related to mean and std as stated in requirements
RegexForMeasurements <- "-std\\(\\)|-mean\\(\\)"
Measurements <- select(X,grep(RegexForMeasurements,Features$V2)) 

# Set activity names from ActivityLabels table
Activity <- as.factor(Y$V1) 
levels(Activity) <- ActivityLabels$V2 

# Get measurement names from feature table
MeasurementNames <- Features[grep(RegexForMeasurements,Features$V2),V2]

# Update measurement names according to my naming convention
MeasurementNames <- gsub("-mean\\(\\)","Mean",MeasurementNames)
MeasurementNames <- gsub("-std\\(\\)","Std",MeasurementNames)
MeasurementNames <- gsub("-","",MeasurementNames)
MeasurementNames <- paste0(toupper(substr(MeasurementNames, 1, 1)), substr(MeasurementNames, 2, nchar(MeasurementNames)))

# Append "Avg" before measurement name since that is the aggregation we will use
MeasurementNames <- paste0("Avg",MeasurementNames)

names(Measurements) <- MeasurementNames
names(Subject) <- "Subject"

# Merge Activity, Subject and Measurements table
TidyData <- cbind(Activity,Subject) %>%
        cbind(Measurements) %>%
# Group by Activity and Subject and calculate mean for remaining columns
          group_by(Activity,Subject) %>%
        summarise_all(mean)

# Write TidyData table to text file in the direcory "UCI HAR Dataset"
write.table(TidyData,"TidyData.txt",row.name=FALSE)


