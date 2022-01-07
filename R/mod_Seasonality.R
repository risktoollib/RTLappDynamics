#' Seasonality UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import feasts
#' @import fabletools
#' @import gt
mod_Seasonality_ui <- function(id){
  ns <- NS(id)
  tagList(shiny::column(
    12,

    tags$h3(tags$span(style = "color:lime;font-style: italic;font-size:1.0em", "About seasonality...")),
    tags$ul(
      tags$li("In prices, supply, demand or due to grade specification?"),
      tags$li("True seasonality occurs when storage is required to balance supply and demand at a seasonal periodicity."),
      tags$li("Storage agents are compensated for storing which creates seasonality in prices via a market contango between build and draw periods"),
      tags$li("US Natural Gas is a prime example whereas Crude oil has little physical constraints in global movements.")
    ),
    shiny::plotOutput(ns("seasonPlot")),
    tags$h3(tags$span(style = "color:lime;font-style: italic;font-size:1.0em", "Seasonality and Trend Strength")),
    tags$p("This area is for discussion with whomever presents this app."),
    tags$p("I highly recommend ",a("Forecasting: Principles and Practice by Rob J Hyndman and George Athanasopoulos",href = "https://otexts.com/fpp3/",.noWS = "outside")),
    tags$p("The specific chapter for interpretion of this table is at ",a("STL Features",href = "https://otexts.com/fpp3/stlfeatures.html",.noWS = "outside")),
    gt::gt_output(ns("seasonTable"))
  ))
}

#' Seasonality Server Functions
#'
#' @noRd
mod_Seasonality_server <- function(id, r){
  moduleServer( id, function(input, output, session){

    ns <- session$ns

    # plot
    output$seasonPlot <- shiny::renderPlot({
      r$tsi %>% feasts::gg_subseries(value)
    })

    # STL statistics
    output$seasonTable <- gt::render_gt({
      value <- seasonal_strength_year <- seasonal_peak_year <- seasonal_trough_year <- Trend <- Seasonality <- NULL
      r$tsi %>%
        fabletools::features(value, feasts::feat_stl) %>%
        dplyr::transmute(Trend = seasonal_strength_year,
                         Seasonality = seasonal_strength_year,
                         Peak = month.abb[seasonal_peak_year],
                         Trough = month.abb[seasonal_trough_year]) %>%
        gt::gt() %>%
        gt::tab_header(
          title = "Trend and Seasonality Statistics",
          subtitle = "Seasonality and Trends in percentage statistics from zero to one."
          ) %>%
        gt::fmt_percent(columns = c(Trend,Seasonality), decimals = 0) %>%
        gt::data_color(
          columns = c(Trend,Seasonality),
          colors = scales::col_numeric(palette = c("white", "yellow", "orange", "red"),
            domain = c(0, 1))
        ) %>%
        gt::cols_align(align = "center")
    })

  })
}

## To be copied in the UI
# mod_Seasonality_ui("Seasonality_ui_1")

## To be copied in the server
# mod_Seasonality_server("Seasonality_ui_1")
