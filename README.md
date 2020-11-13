README - Dataset Viewer
================

# Motivation

This application was designed to quickly assess the contents of a given
dataset, and answer some “big picture” questions before you start
digging into an analysis.

``` r
library(inspectdf)
library(Lahman)
library(visdat)
library(listviewer)
library(tidyverse)
library(reactable)
library(repurrrsive)
```

## The `flexdashboard`

This is the `data-viewer` as a `flexdashboard`.

    ## dashboard
    ## └── data-vewier-dashboard.Rmd

## The `app`

This is the `data-viewer` as a shiny app.

    ## app
    ## └── app.R

## The `data`

These are example data files for the application.

    ## data
    ## ├── People.csv
    ## ├── People.xlsx
    ## └── got_users_json.json
