# FitBit-Data-Analysis
FitBit Data Business Analysis and Visualization


Overview:
This R code analyzes Fitbit user data to gain insights into their activity, sleep patterns, and usage habits. It loads and merges multiple datasets, cleans the data, calculates daily means, categorizes users into different types based on their activity levels, and visualizes the results using various plots.

Descriptive Features for README:
1. Libraries Used:
Tidyverse
Janitor
Lubridate
Skimr
GGplot2
Dplyr

3. Data Loading and Merging:
Data from multiple CSV files is imported and merged using common identifiers.
Datasets: daily_activity, daily_calories, daily_intensity, daily_steps, daily_sleep, weight_log.

5. Data Cleaning:
Handling missing values (NA) and duplicates.
Converting date formats for consistency.
Cleaning column names for easier processing.

6. Data Analysis:
Calculating daily means for steps, distance, calories, sleep, and time in bed.
Categorizing users into different activity levels: Sedentary, Lightly Active, Moderately Active, Very Active.
Analyzing user types, usage patterns, and correlations between variables.

7. Data Visualization:
User Type Distribution Pie Chart:

Visualizes the distribution of user types based on activity levels.
Segments users into different categories and represents them in a pie chart.
Scatter Plots:

  Daily Steps vs Caloric Expenditure:
  Shows the relationship between daily steps and calories burned.
  Calories vs Very Active Minutes:
  Displays the correlation between calories burned and very active minutes.
  Days Used vs Average Sleep:
  Illustrates the relationship between usage patterns and average sleep duration.

8. Output:
The code outputs visualizations and summary statistics that provide valuable insights into Fitbit user behavior.
Instructions for Running the Code:
Ensure all required libraries are installed.
Modify file paths in the code to match the location of your dataset files.
Run the R script in a suitable R environment.
