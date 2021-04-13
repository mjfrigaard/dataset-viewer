#=====================================================================#
# This is code to create: global.R
# Authored by and feedback to: mjfrigaard
# MIT License
# Version: 2.3
#=====================================================================#

# packages ----------------------------------------------------------------
library(shiny)
library(polished)
library(config)

# configure the global sessions when the app initially starts up.
polished::global_sessions_config(
  app_name = "csviewer-dashboard",
  api_key = "3DM3AENJFfqPsAds3725BRbNdAOhM2I2CT"
)