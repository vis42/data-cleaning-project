# data-cleaning-project

Processes Human Activity Recognition Using Smartphones Data Set, found on <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Repository includes following files:

- *`dataset/`* folder: raw dataset, see `dataset/README.txt` for description of each files in the dataset

- *`run_analysis.R`* : performs analysis of the dataset, results are stored in `summaryByActivity` variable, which summarizes the dataset per activity and subject. The raw data with subset of the fields (mean, std, activity, subject) gets stored in the `allMeasurements` field.

  1. Loads the `featureNames` and removes special character
  2. Finds all the std and mean features names
  3. Pre-loads activity labels
  4. Defines a reusable function to load either test/training of dataset
     - load measurements and specify the column names using `featureNames`
     - load the subject data
     - load the activities and specify the activity labels
     - combine all three data into single table
     - convert the data frame to tibble and downselect only the mean, std, activity, and subject fields
  5. Load training and test dataset, and combine
  6. Compute mean of each field per activity and subject
