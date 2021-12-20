#' VolCor UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_VolCor_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::plotOutput(ns("plot"))


  )
}

#' VolCor Server Functions
#'
#' @noRd
mod_VolCor_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$plot <- renderPlot({
      shinipsum::random_ggplot()
    })

  })
}

## To be copied in the UI
# mod_VolCor_ui("VolCor_ui_1")

## To be copied in the server
# mod_VolCor_server("VolCor_ui_1")
