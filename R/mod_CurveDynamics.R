#' CurveDynamics UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import RTL

mod_CurveDynamics_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::column(12,
                  tags$h3(tags$span(style = "color:lime;font-style: italic;font-size:1.0em", "Forming your hypotheses of the pricing dynamics")),
                  tags$ul(
                    tags$li("Root your thinking on fundamentals (SD Balance and the physical supply chain)"),
                    tags$li("Forward prices are the expected spot price with today's information set."),
                    tags$li("What can you infer from the volality of the front contract?"),
                    tags$li("How is the forward curve moving along with flat price and why?")
                  ),
                  shiny::plotOutput(ns("fwdCurve"))
                  )
  )
}

#' CurveDynamics Server Functions
#'
#' @noRd
mod_CurveDynamics_server <- function(id, r) {

  moduleServer(id,
               function(input, output, session) {
                # browser()
                 output$fwdCurve <-  renderPlot({
                   df <- r$datWide
                   cmdty <- r$cmdty
                   RTL::chart_fwd_curves(
                     df = df,
                     cmdty = cmdty,
                     weekly = TRUE,
                     main = "Forward Curves",
                     ylab = ifelse(r$contract == "NG","$ per mmBTU","$ per bbl"),
                     xlab = "",
                     cex = 2
                   )
                 })
               })
}

## To be copied in the UI
# mod_CurveDynamics_ui("CurveDynamics_ui_1")

## To be copied in the server
# mod_CurveDynamics_server("CurveDynamics_ui_1")
