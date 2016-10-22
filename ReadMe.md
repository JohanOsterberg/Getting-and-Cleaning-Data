### Contents of this submission:  
* run_analysis.R  
* Codebook.md  
* TidyData.txt

### Steps conducted in run_analysis.R
1. Download compressed data file for project and unzip files
2. Read files into data tables
3. Merge test and train data tables
4. Select features containing related to mean and std as stated in requirements
5. Get activity names from activity_labels table
6. Get measurement names from features table
7. Give measurements descriptive names according to my naming convention
8. Merge Activity, Subject and Measurements tables
9. Group by Activity and Subject and calculate mean for each measurement to get a tidy data set according to the principles from Hadley Wickhams paper "Tidy Data"
10. Write the the tidy data set to TidyData.txt

### Codebook.md
Contains a description of the data set in TidyData.txt

### View TidyData.txt in R
address <- "XXX"  
address <- sub("^https", "http", address)  
data <- read.table(url(address), header = TRUE)  
View(data)