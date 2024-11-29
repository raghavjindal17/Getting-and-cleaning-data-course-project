# Coursera-Cleaning-data-analysis-project
This is the README file for the 'run_analysis.R' script.

The 'README_souce' file contains information on the UCI HAR dataset files and sub-directories. This is the code book, from the data source, for the data files and inlcudes all attributions for the data set.
In the run_annalysis.r scripts there is code chunk to open this README file directly.

The run_analysis script is about downloading and processing two data set, combining several data frames into a single data frame. Then goruping and selecting a sub-set of variables, and summarizing the subsets.
The final grouped_df dataframe is a tidy df grouped by experiment activities within eperiment subjects. 

Code steps:

1) Load tidyverse into the library. This includes all tidy packages needed for the script.

2) The following will load the data files into the current working directory.
    a.  Create a variable ‘url’ and assign the source file to it: “https://d396qusza40orc.cloudfront.net/getdata%		  	2Fprojectfiles%2FUCI%20HAR%20Dataset.zip”
    b. Create and Assign the zip file name: ( "UCI_HAR_Dataset.zip") into a temp file.
    c. Use download.file to download the source file and load it to the temp file.

3) Use unzip() to unzip the “tempfile” which will create the necessary sub-directories within the current working directory. 

4) Code is included in the script to open the source readme.txt file, using read.lines(), which further outlines the detail of the sub-directory structure and the information contained within each file.

5) Load the following files which will be applied to the detail data later in the script
	a. feature_labels using read.table from the file: "UCI HAR Dataset/features.txt"
	b. activity_lables from the file: "UCI HAR Dataset/activity_labels.txt”

6) As the readme.txt outlines; there are two primary sets of data, each within the train and test sub-directories. The following outlines the process applied to each of these subsets using the test subset as an example. The process is identical for each subset using the appropriate train or test datafiles.
	a. Use read.table() to read into R each of the following files:
		i. "UCI HAR Dataset/test/X_test.txt"
		ii. "UCI HAR Dataset/test/y_test.txt"
		iii. "UCI HAR Dataset/test/subject_test.txt"
	b. The following steps will develop the test_data dataframe from the loaded files, adding the feature labels, experiment 	participant subject numbers,	 and the activity number identifiers from the test_data_y df.
		i. Create a variable label_names subsetting from the second variable of the feature_labels df. Use colnames() to 		apply lable_names to each column of the test_data_X  df. Note: there are several duplicate column names in the 			dataset. After researching this apparently in not unusual for complex sensor data. They do not represent the 			same data elements so should not be merged into a single variable. As they will not be included in the final 			tidy data set, I’ve chosen not to rename them.
		ii. Create the test_data df by using cbind() to add the column test_data_y to the test_data_X df.
		iii. Using cbind() add the column subject_test to the test_data DF.
		iv. Use the names() to add names to the variable 1 and 2 (subject_test data and activity number data)
	c. Repeat the above steps for the train data file set.

7) Use rbind() to combine the test_data and train_data dataframes to create the HAR_data dataframe

8) Per the instructions select the variables that represent means and standard deviations using the dplyr:select(). Arguments include all the necessary identifier variables as well variables containing reference to mean or “std” (standard deviation)

9) Using a left_join apply the activity_labels to the HAR_data df. Use rename() to name the variable activity_label in the df. And locate it in the appropriate order using relocate()

10) Group the HAR_data df by activity (activity_label) within subjects (subject_number)

Step 11 completes the assignment as outlined in the project specs. The data fits the tidy definition:
	1. Each column represents a single variable and all of the occurrences of that variable.
	2. Each row is a single observation across all variables. 
	3. Each cell is a single value of that observation/variable. 
