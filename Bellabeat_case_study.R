## Loading Libraries

library(tidyverse)
library(janitor)
library(tidyr)
library(lubridate)
library(dplyr)
library(ggplot2)
library(skimr)



## Importing CSV files

daily_activity <- (read_csv("dailyActivity_merged.csv"))
daily_calories <- (read_csv("dailyCalories_merged.csv"))
daily_intensity <- (read_csv("dailyIntensities_merged.csv"))
daily_steps <- (read_csv("dailySteps_merged.csv"))
daily_sleep <- (read_csv("sleepDay_merged.csv"))
weight_log <- (read_csv("weightLogInfo_merged.csv"))


## Previewing Data and preliminary scan for inconsistencies

## Checking Sample Size Per Data Set


## Vectors
df_name <- c("activity", "calories", "intensity", "steps", "sleep", "log")
number <- c(n_distinct(daily_activity$Id), n_distinct(daily_calories$Id), n_distinct(daily_intensity$Id), n_distinct(daily_steps$Id), n_distinct(daily_sleep$Id), n_distinct(weight_log$Id))

check_sample <- data.frame(df_name = df_name, unique_id = number)
view(check_sample)

## daily_sleep and weight_log have lowered sample size at 24 and 8 respectively; 8 would be too low for any significant findings and thus cannot be used.
## daily_activity already contains the merged data from calories, intensity, and steps which only leaves sleep to be merged to activity

view(daily_sleep)

## Change "sleep day" column to remove time format so that it can be matched to "activity day" in merge

daily_sleep2 <- separate(daily_sleep, SleepDay, into = c("ActivityDate", "time"), sep = " ")
view(daily_sleep2)

## Merge activity to sleep2

fitbit_merged <- merge(daily_activity, daily_sleep2, by = c("Id", "ActivityDate"))
view(fitbit_merged)
select(fitbit_merged, Id, ActivityDate, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed)

## data cleaning

fitbit_merged$ActivityDate <- lubridate::mdy(fitbit_merged$ActivityDate) ## Convert to date format
head(fitbit_merged)


fitbit_na <- colSums(is.na(fitbit_merged))  ## look for na in data
fitbit_na_df <- as.data.frame(fitbit_na)
print(fitbit_na_df) 

fitbit_merged <- fitbit_merged %>%  ## remove na from data
  distinct() %>%
  drop_na()  

sum(duplicated(fitbit_merged))  ## checking for duplicates

fitbit_merged <- fitbit_merged %>% ## cleaning col names
  clean_names() %>%
  rename_with(tolower) %>%
  rename(date = activitydate)

## Finding Daily Means

daily_mean <- fitbit_merged %>%
  group_by(id) %>%
  summarise(m_steps = mean(totalsteps), m_distance = mean(totaldistance), m_calories = mean(calories), m_sleep = mean(totalminutesasleep), m_ttb = (mean(totaltimeinbed)))

view(daily_mean)


## Creating User Types

user_types <- daily_mean %>%
  mutate(user_type = case_when(
    m_steps < 4000 ~ "Sedentary", 
    m_steps >= 4000 & m_steps < 7500 ~ "Lightly Active", 
    m_steps >= 7500 & m_steps < 10000 ~ "Moderately Active", 
    m_steps >= 10000 ~ "Very Active"
  ))

view(user_types)

user_type_per <- user_types %>%  ##Percentage of total users (n)
  group_by(user_type) %>%
  summarise(total = n()) %>%
  mutate(totals = sum(total)) %>%
  group_by(user_type) %>%
  summarise(total_percent = (total/totals), total, totals) %>%
  mutate(labels = scales::percent(total_percent))


## Calc Days Used by User in a month

days_used_pm <- fitbit_merged %>%
  group_by(id) %>%
  summarise(days_used = sum(n())) %>%
  mutate(usage = case_when(
    days_used <= 10 ~ "Low Use", 
    days_used <=20 ~ "Moderate Use",
    days_used <= 31 ~ "High Use",
    
  ))

view(days_used_pm)

## Merge days_used_pm with user_types DF to create avaerage per user table for key metrics

user_averages <- merge(user_types, days_used_pm, by = "id")
view(user_averages)


## User Type Distribution Pie Chart
ggplot(data = user_type_per, mapping = aes(x = "", y = (labels), fill = user_type)) +
  geom_col(color = "black") +
  geom_text(aes(label = labels),
            size = 3,
            position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y") +
  theme_minimal() +
  labs(title = "User Type Distribution (N=24)") +
  theme(plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks = element_blank(), 
        axis.text = element_blank(), 
        panel.grid = element_blank()
        )

## Steps vs Calories Scatter

ggplot(data = fitbit_merged, mapping = aes(x = totalsteps, y = calories)) +
  geom_jitter() + geom_smooth(color = "red") +
  labs(title = "Daily Steps vs Caloric Expendature")

ggplot(data = fitbit_merged, mapping = aes(x = calories, y = veryactiveminutes)) +
  geom_jitter() + geom_smooth(color = "red")


ggplot(data = user_averages, mapping = aes(x = days_used, y = m_sleep)) +
  geom_jitter() + geom_smooth(color = "red")



    
