#' CurveDynamics UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList

mod_CurveDynamics_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::column(12,
                  tags$h3(tags$span(style = "color:blue;font-style:italic", "...form your hypotheses of the pricing dynamics...")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "+ Root your thinking on fundamentals (SD Balance and the physical supply chain)")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "+ Forward prices are the expected spot price with today's information set.")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "+ What can you infer from the volality of the front contract?")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "+ How is the forward curve moving along with flat price and why?")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "+ ...")),
                  shiny::plotOutput(ns("plot"))
  )
  )
}

#' CurveDynamics Server Functions
#'
#' @noRd
mod_CurveDynamics_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$plot <- renderPlot({
      shinipsum::random_ggplot()
    })
  })
}

## To be copied in the UI
# mod_CurveDynamics_ui("CurveDynamics_ui_1")

## To be copied in the server
# mod_CurveDynamics_server("CurveDynamics_ui_1")
