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
    shiny::column(12,
                  tags$h3(tags$span(style = "color:blue", "Volatility is a function of Delivery Timing")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "Why would think so in the context of economics?")),
                  shiny::plotOutput(ns("volByDelivery")),
                  shiny::plotOutput(ns("volBoxplot")),
                  #plotOutput("vol1", height = "400px"),
                  #plotly::plotlyOutput("vol2", height = "400px"),
                  tags$h3(tags$span(style = "color:blue", "Volatility is NOT constant through time")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "What measure of risk are you using to proxy uncertainty?")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "What implications does it have for your analysis?")),
                  #numericInput("window","Select # days for a rolling standard deviation:",
                  #              value = 60, min = 20,step = 10, width = "600px"),
                  shiny::plotOutput(ns("volMeasures")),
                  #plotly::plotlyOutput("volInTime", height = "400px"),
                  tags$h3(tags$span(style = "color:blue", "Introducing Correlation")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "Same grade, same delivery location, DIFFERENT delivery timing = Same information set.")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "Correlation only informs the DIRECTIONAL relationship.")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "So what are the implications for spread trading? NEXT TAB")),
                  #plotOutput("correlation", height = "600px"),
                  shiny::plotOutput(ns("correlation"))
    )
  )
}

#' VolCor Server Functions
#'
#' @noRd
mod_VolCor_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$volByDelivery <- renderPlot({
      shinipsum::random_ggplot()
    })
    output$volBoxplot <- renderPlot({
      shinipsum::random_ggplot()
    })
    output$volMeasures <- renderPlot({
      shinipsum::random_ggplot()
    })
    output$correlation <- renderPlot({
      shinipsum::random_ggplot()
    })

  })
}

## To be copied in the UI
# mod_VolCor_ui("VolCor_ui_1")

## To be copied in the server
# mod_VolCor_server("VolCor_ui_1")
