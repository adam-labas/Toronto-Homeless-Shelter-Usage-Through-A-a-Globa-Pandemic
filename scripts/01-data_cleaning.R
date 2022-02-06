#### Preamble ####
# Purpose: Download and clean data from opendatatoronto
# Author: Adam Labas
# Data: 6 Febuary 2022
# Contact: adam.labas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the data from opendatatoronto and saved it to inputs/data
# - Don't forget to gitignore it!

# Any other information needed?


#### Workspace setup ####
library(tidyverse)
library(janitor)
library(dplyr)
library(tidyr)
library(opendatatoronto)
library(knitr)
library(lubridate)
library(patchwork)


#### Read in the raw data. ####

## Download Data ###
# Data located at the following URL: 
# https://open.toronto.ca/dataset/toronto-shelter-system-flow/

# Data sets are grouped into packages that have multiple data sets.
# Let's start by looking at the big package through a unique key  obtained at 
# the link above.

# get package
package <- show_package("ac77f532-f18b-427c-905c-4ae87ce69c93")
package

# A package can contain multiple resources with various data sets. In the case
# of our package, there is only one resource, the desired data so we access it.
# get all resources for this package
resources <- list_package_resources("ac77f532-f18b-427c-905c-4ae87ce69c93")
resources

# We need the unique key from that list of resources. We use get_resources() 
# to access and load it.
monthly_shelter_usage <- 
  resources %>% 
  get_resource()


### Save the data in our inputs folder in case the data is removed or
# relocated from the URL provided above ###
write.csv(x = monthly_shelter_usage,
          file = "inputs/data/raw.csv")

### Clean the data and only take the information we wish to use ###

# Add a total column
total <- c()
for (i in 1:length(monthly_shelter_usage$ageunder16)){
  print(i)
  total_users = sum(monthly_shelter_usage[i,10:14])
  print(monthly_shelter_usage[i,10:14])
  print(total_users)
  total[i] <- total_users
}

# Add the vector total to the end of the tibble.
monthly_shelter_usage$total <- total
monthly_shelter_usage

### Now we clean the data and take only the rows we want

cleaned_data <- monthly_shelter_usage %>% 
  select(`date(mmm-yy)`,population_group, moved_to_housing, ageunder16, 
         `age16-24`, `age25-44`, `age45-64`, age65over, total)


# Remove the different population groups except for All Population 

all_population <- cleaned_data[monthly_shelter_usage$population_group == "All Population",]


# Add a column with 2020 or 2021 depending on the year.
year_2020_and_2021 <- c("2020", "2020", "2020", "2020", "2020", "2020", "2020", 
                        "2020", "2020", "2020", "2020", "2020", "2021", "2021", 
                        "2021", "2021", "2021", "2021", "2021", "2021", "2021", 
                        "2021", "2021","2021")



#("2020", "2020", "2020", "2020", "2020", "2020", "2020", 
# "2020", "2020", "2020", "2020", "2020", "2021", "2021", 
# "2021", "2021", "2021", "2021", "2021", "2021", "2021", 
# "2021", "2021","2021"))

#("20", "20", "20", "20", "20", "20", "20", "20", "20", 
# "20", "20", "20", "21", "21", "21", "21", "21", "21", 
# "21", "21", "21", "21", "21","21")


all_population$year <- year_2020_and_2021

# Add a months column as numeric variable from 1-12
month_2020_and_2021 <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", 
                         "10", "11", "12", "01", "02", "03", "04", "05", "06", 
                         "07", "08", "09", "10", "11", "12")


all_population$month <- month_2020_and_2021

# Add a column with the last day of every month
day_2020_and_2021 <- c("31", "29", "31", "30", "31", "30", "31", "31", "30", 
                       "31", "30", "31", "31", "28", "31", "30", "31", "30", 
                       "31", "31", "30", "31", "30", "31")
all_population$day <- day_2020_and_2021


dates = c()
for (i in 1:length(all_population$ageunder16)){
  print(i)
  # print(all_population$year[i])
  # print(all_population$month[i])
  # print(all_population$day[i])
  string_date = paste(all_population$year[i], all_population$month[i], all_population$day[i], sep="/")
  print(string_date)
  date_new = as.Date(string_date, origin = "1970-01-01")
  print(date_new)
  dates[i] <- date_new
}

all_population$date <- as.Date(dates, origin = "1970-01-01")



### Save the data in our inputs folder in case the data is removed or
# relocated from the URL provided above ###

write.csv(x = cleaned_data,
          file = "inputs/data/clean.csv")

write.csv(x = all_population,
          file = "inputs/data/all_pop.csv")



         