# =====================================================================#
# This is code to create: sample data for dataset viewer app
# Authored by and feedback to mjfrigaard@gmail.com
# MIT License
# Version: 0.1.2 ----
# =====================================================================#


#

# packages ----------------------------------------------------------------

library(tidyverse)
library(janitor)

# import ------------------------------------------------------------------

# import
SampleDataSet <- readr::read_csv(file = "data/mimic-iii-v1.4/PATIENTS.csv") %>% 
  dplyr::slice_sample(.data = ., prop = .25)

glimpse(SampleDataSet)

# export 
write_csv(x = SampleDataSet, file = "dashboard/SampleDataSet.csv")
  