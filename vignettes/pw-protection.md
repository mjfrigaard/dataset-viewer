Password protecting your flexdashboard
================
Martin Frigaard

## Motivation

We want to password protect our flexdashboard with a username/password
that we give to users, and we want the app not to run (or initialize)
until a valid password has been given and authenticated.

The dashboard is deployed at this url:
<https://mjfrigaard.shinyapps.io/csviewer-dashboard/>

### Dashboard application folder structure

The folder tree for the `csviewer-dashboard` is below:

``` r
../dashboard
├── SampleDataSet.csv
├── csvewier-dashboard.Rmd
├── rsconnect
│   └── documents
│       └── csviewer-dashboard.Rmd
│           └── shinyapps.io
│               └── mjfrigaard
│                   └── csviewer-dashboard.dcf
└── sampledatainfo.md
```

------------------------------------------------------------------------

## Package for PW protection

The [`polished` package](https://github.com/Tychobra/polished) handles
authentication for Shiny applications. They have some great resources
for getting started on their website
[here](https://polished.tech/docs/01-get-started).

### Register with polished

Click on this link to register for a polished account:
<https://dashboard.polished.tech/?page=sign_in&register=TRUE>

After registering, you need to add an application to the polished
dashboard.

<img src="img/02-polished-landing.jpeg" width="1406" />

Navigate to the Shiny Apps page and add the `csviewer-dashboard`
application and click on **Add Shiny App**. I use the following **App
Name** and **App URL**:

App Name: `csviewer-dashboard`  
App URL: `https://mjfrigaard.shinyapps.io/csviewer-dashboard/`

<img src="img/03-add-shiny-app.jpg" width="598" />

## Get API Key

Click on the **Account** tab on the sidebar, then **Show Secret** (just
to verify), and **Copy**.

## Install and configure `polished` (RStudio)

Back in RStudio, install and load the `polished` package

``` r
install.packages("polished")
library(polished)
```

Configure the `polished::global_sessions_config()` function with your
`polished.tech secret API key` you copied above. This should be stored
in a `global.R` file the same folder as the application [file per the
instructions](https://polished.tech/docs/01-get-started).

``` r
# inside a global.R script
library(shiny)
library(polished)
library(config)

# configure the global sessions when the app initially starts up.
polished::global_sessions_config(
  app_name = "csviewer-dashboard",
  api_key = "3DM3AENJFfqPsAds3725BRbNdAOhM2I2CT"
  # don't worry--I've since deleted this application key!
)
```

**Adding this global.R file doesn’t work for the `flexdashboard`,
though**.

# Troubleshooting

Below are the methods I used to try and get the `flexdashboard` set up
with `polished`.

## Re-structuring application folders

I re-structured my files and folders like the ones in [this
repo](https://github.com/Tychobra/polished_example_apps/tree/master/05_flex_dashboard).

``` r
└── 05_flex_dashboard/
    ├── app.R
    ├── config.yml
    └── www/
        ├── flex_dash.Rmd
        └── flex_dash.html
```

The `05_flex_dashboard/` folder contains the following files:

1.  `app.R`

``` r
app_config <- config::get()

polished::secure_static(
  "flex_dash.html",
  global_sessions_config_args = list(
    "app_name" = "05_flex_dashboard",
    "api_key" = app_config$api_key
  )
)
```

2.  `config.yml`

``` yml
default:
  api_key: "<your secret API key from dashboard.polished.tech>"
```

I restructured my folders to mimic the `05_flex_dashboard` repo.

### New folder structure

The `dashboard/` is analogous to the `05_flex_dashboard/` folder.

``` r
../dashboard
├── app.R
├── config.yml
└── csviewer-dashboard
    ├── SampleDataSet.csv
    ├── csviewer-dashboard.Rmd
    ├── rsconnect
    │   └── documents
    │       └── csviewer-dashboard.Rmd
    │           └── shinyapps.io
    │               └── mjfrigaard
    │                   └── csviewer-dashboard.dcf
    └── sampledatainfo.md
```

2.  The `app.R` file was changed to:

``` r
library(config)
library(polished)

app_config <- config::get()

polished::secure_static(
  "csviewer-dashboard.html",
  global_sessions_config_args = list(
    "app_name" = "csviewer-dashboard",
    "api_key" = app_config$api_key
  )
)
```

3.  The `config.yml` file was created with the following contents:

``` yml
default:
  api_key: "3DM3AENJFfqPsAds3725BRbNdAOhM2I2CT"
```

The `csviewer-dashboard.Rmd` was republished, and the `app.R` file was
run.

## Error 1 (`config.yml`)

The `config::get()` function was giving the following error:

``` r
Error in config::get() : 
  Config file config.yml not found in current working directory or parent directories
```

## Error 2 (`config.yml`)

Even after setting the working directory, this file was not being read
by `config::get()`.

``` r
Warning message:
In readLines(con) :
  incomplete final line found on '/dataset-viewer/dashboard/config.yml'
```

## Error 3 (`app.R`)

I changed the `app.R` file to take both arguments as strings,

``` r
library(config)
library(polished)

# app_config <- config::get()

polished::secure_static(
  "csviewer-dashboard.html",
  global_sessions_config_args = list(
    "app_name" = "csviewer-dashboard",
    "api_key" = "3DM3AENJFfqPsAds3725BRbNdAOhM2I2CT"
  )
)
```

and when I ran it, I got the following error:

<img src="img/05-not-found-error.jpg" width="1020" />

Then I ran the `csviewer-dashboard.Rmd` document to try and see if it
would recognize the temporary version of `csviewer-dashboard.html`
displayed the **Viewer** pane, but I got nothing.

<img src="img/06-not-found-error-2.png" width="1907" />

## Question

**Does the `polished` package have a `polished::secure_` variant to pass
a `flexdashboard` with the YAML header set to `runtime: shiny`?**

Sorry–that was long-winded.
