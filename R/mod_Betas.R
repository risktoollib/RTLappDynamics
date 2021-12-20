#' Betas UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_Betas_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::plotOutput(ns("plot"))


  )
}

#' Betas Server Functions
#'
#' @noRd
mod_Betas_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$plot <- renderPlot({
      shinipsum::random_ggplot()
    })

  })
}

## To be copied in the UI
# mod_Betas_ui("Betas_ui_1")

## To be copied in the server
# mod_Betas_server("Betas_ui_1")
