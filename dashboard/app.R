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
