#' Seasonality UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_Seasonality_ui <- function(id){
  ns <- NS(id)
  tagList(shiny::column(
    12,

    tags$h3(tags$span(style = "color:lime;font-style: italic;font-size:1.0em", "Seasonality in Supply, Demand, Prices or Grade : What is the difference?")),
    tags$h5(tags$span(style = "color:fuchsia;font-style:italic", "Work In Progress")),
    shiny::textOutput(ns("season1"))
  ))
}

#' Seasonality Server Functions
#'
#' @noRd
mod_Seasonality_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$season1 <- shiny::renderText({
      shinipsum::random_text(nchars = 200)
    })

  })
}

## To be copied in the UI
# mod_Seasonality_ui("Seasonality_ui_1")

## To be copied in the server
# mod_Seasonality_server("Seasonality_ui_1")
