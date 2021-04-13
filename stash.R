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
skimr::skim(SampleDataSet)

# The date of birth was then set to exactly 300 years before their first 
# admission.

# export 
write_csv(x = SampleDataSet, file = "dashboard/SampleDataSet.csv")


# shiny::radioButtons(inputId = "sep", label = "Separator",
#                    choices = c(Comma = ",",
#                                Semicolon = ";",
#                                Tab = "\t"),
#                    selected = ",")
# shiny::radioButtons(inputId = "quote", label = "Quote",
#                    choices = c(None = "",
#                                "Double Quote" = '"',
#                                "Single Quote" = "'"),
#                    selected = '"')


# df <- read.csv(input$csvfiledata$datapath,
#          header = input$header,
#          sep = input$sep,
#          quote = input$quote)
