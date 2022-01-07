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
                  tags$h3(tags$span(style = "color:lime;font-style: italic;font-size:1.0em", "Forming your hypotheses on the pricing dynamics")),
                  tags$ul(
                    tags$li("Root your thinking on fundamentals:"),
                    tags$ul(
                      tags$li("The physical supply chain from production to end users."),
                      tags$li("Supply-Demand ('SD') balances.")
                    ),
                    tags$li("Forward prices are the current expection of future spot prices with today's information set."),
                    tags$li("What can you infer from the volality of the front contract and its transmission mechanism in contracts for later delivery?")
                  ),
                  shiny::plotOutput(ns("fwdCurve"), height = "800px")
                  )
  )
}

#' CurveDynamics Server Functions
#'
#' @noRd
mod_CurveDynamics_server <- function(id, r) {

  moduleServer(id,
               function(input, output, session) {
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
