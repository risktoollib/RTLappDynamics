#' SpreadDynamics UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_SpreadDynamics_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::column(
      12,
      tags$h3(tags$span(style = "color:blue", "Is Structure (c1c2) related to flat price?")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "A general relationship not useful for trading purposes.")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "What if you reframe the problem by making it conditional upon FP increases from each cyclical low?")),
      shiny::plotOutput(ns("structFlatPrice")),
      #plotly::plotlyOutput("spdFP", height = "600px"),
      tags$h3(tags$span(style = "color:blue", "Reframe the Problem as Capacity Utilization (CL, HO & RB only)")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "Imbalanced markets (close to operational tank tops or bottom) are where it matters.")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "Reframe the problem as capacity utilization.")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "Use analytics from this chart and predict where spreads should be based on your SD model for storage levels.")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "Then compare your results with the current forward curve and if different put a trade on!")),
      shiny::plotOutput(ns("structUtilization")),
      #plotly::plotlyOutput("spdUtil", height = "600px"),
      tags$h3(tags$span(style = "color:blue", "Shape of intermonth spread curve")),
      shiny::plotOutput(ns("meanIntraMonthSruct"))
      #numericInput("bucket","Select width of c1c2 groups e.g. 0.25 will group between -0.125 to +0.125 into the 0 bucket:",
      #              value = 0.50, min = 0.25, step = 0.25,width = "800px"),
      #plotly::plotlyOutput("spdDyn", height = "600px")
    )
  )
}

#' SpreadDynamics Server Functions
#'
#' @noRd
mod_SpreadDynamics_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$structFlatPrice <- renderPlot({
      shinipsum::random_ggplot()
    })
    output$structUtilization <- renderPlot({
      shinipsum::random_ggplot()
    })
    output$meanIntraMonthSruct <- renderPlot({
      shinipsum::random_ggplot()
    })
  })
}

## To be copied in the UI
# mod_SpreadDynamics_ui("SpreadDynamics_ui_1")

## To be copied in the server
# mod_SpreadDynamics_server("SpreadDynamics_ui_1")
