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
library(opendatatoronto)


# Read in the raw data. 
#raw_data <- readr::read_csv("inputs/data/raw_data.csv"
                     )
################## clean data here ###################################

# Just keep some variables that may be of interest (change 
# this depending on your interests)
# names(raw_data)
# 
# reduced_data <- 
#   raw_data %>% 
#   select(first_col, 
#          second_col)
# rm(raw_data)
         

#### What's next? ####

library(opendatatoronto)
library(dplyr)

### Download Data ###
# Data located at the following URL: 
# https://open.toronto.ca/dataset/toronto-shelter-system-flow/

# Datasets are grouped into packages that have multiple datasets that are
# relevant to that topic. So we first look at the package using a unique
# key that we obtain from the dataset website linked above.

# get package
package <- show_package("ac77f532-f18b-427c-905c-4ae87ce69c93")
package

# get all resources for this package
resources <- list_package_resources("ac77f532-f18b-427c-905c-4ae87ce69c93")

# We need the unique key from that list of resources.

# There is only one resource in our case so get_resources() will load it.
monthly_shelter_usage <- 
  resources %>% 
  get_resource()

monthly_shelter_usage

### Save the data in our inouts folder incase the data is removed or
# relocated from the provided URL ###

write.csv(x = monthly_shelter_usage,
          file = "inputs/data/monthly_shelter_usage.csv")

         