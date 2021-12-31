# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
###################################
#### CURRENT FILE: DEV SCRIPT #####
###################################

# Engineering

#download.file("https://www.w3schools.com/w3css/tryw3css_templates_dark_portfolio.htm", "inst/app/www/template.html")
#file.copy("~/core/hex/hex-dynamics.png", "inst/app/www/golem-hex_250.png")

## Dependencies ----
## Add one line by package you want to add as dependency
attachment::att_from_rscripts()
usethis::use_package("shinipsum")
usethis::use_package("thinkr")
usethis::use_package("shiny")
usethis::use_package("RTL")
usethis::use_package("dplyr")
usethis::use_package("tidyr")
usethis::use_package("ggplot2")
usethis::use_package("scales")
usethis::use_package("ggtext")
usethis::use_package("plotly")
usethis::use_package("tibbletime")
usethis::use_package("lubridate")
usethis::use_package("rlang")
usethis::use_package("zoo")
usethis::use_package("PerformanceAnalytics")
usethis::use_package("timetk")
usethis::use_package("readr")
usethis::use_package("bslib")
usethis::use_package("tsibble")
usethis::use_package("feasts")
usethis::use_package("fabletools")
usethis::use_package("gt")





### not added yet



## Add modules ----
## Create a module infrastructure in R/

# inputs modules
golem::add_module( name = "contract" )
#golem::add_module( name = "datLong" )
#golem::add_module( name = "datWide" )

# compute modules
golem::add_module( name = "CurveDynamics" )
golem::add_module( name = "VolCor" )
golem::add_module( name = "Betas" )
golem::add_module( name = "Seasonality" )
golem::add_module( name = "SpreadDynamics" )


## Add helper functions ----
## Creates fct_* and utils_*
golem::add_fct( "helpers" )
golem::add_utils( "helpers" )

## External resources
## Creates .js and .css files at inst/app/www
golem::add_js_file( "script" )
golem::add_js_handler( "handlers" )
golem::add_css_file( "custom" )

## Add internal datasets ----
## If you have data in your package
#usethis::use_data_raw( name = "my_dataset", open = FALSE )

## Tests ----
## Add one line by test you want to create
usethis::use_test( "app" )

# Documentation

## Vignette ----
usethis::use_vignette("RTLappDynamics")
devtools::build_vignettes()

## Code Coverage----
usethis::use_github()
usethis::use_github_action()

# Chose one of the three
# See https://usethis.r-lib.org/reference/use_github_action.html
usethis::use_github_action_check_release()
#usethis::use_github_action_check_standard()
#usethis::use_github_action_check_full()

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")

