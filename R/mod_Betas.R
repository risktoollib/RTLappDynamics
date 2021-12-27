#' Betas UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @import RTL
#' @importFrom shiny NS tagList
#' @rawNamespace import(plotly, except = last_plot)

mod_Betas_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::column(12,
                  tags$h3(tags$span(style = "color:blue", "Hedge Ratios of Contracts vs Front Contract")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "Time spreads are a function of correlation times the ratio of volatility")),
                  plotly::plotlyOutput("hedgeRatios"),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "See how they change through time.")),
                  #numericInput("days","Select Last Number of Days to Compare Betas with Lon Run fits:",
                  #              value = 100, min = 60, width = "600px"),
                  shiny::column(6,
                                tags$h3(tags$span(style = "color:blue","Betas - All History ")),
                                shiny::plotOutput(ns("betasAll"))
                                #tableOutput("betas")
                  ),
                  shiny::column(6,
                                tags$h3(tags$span(style = "color:blue","Betas - Recent Selected Days")),
                                shiny::plotOutput(ns("betasSelected"))
                                #tableOutput("betasRecent")
                  )
    )

  )
}

#' Betas Server Functions
#'
#' @noRd
mod_Betas_server <- function(id, r){
  moduleServer( id, function(input, output, session){

    #ns <- session$ns # WHY WE DON'T NEED THIS ANYMORE

    output$hedgeRatios <- plotly::renderPlotly({
      x <- series <- NULL
      x <- r$datLong
      x <- x %>% dplyr::mutate(series = readr::parse_number(series)) %>% dplyr::group_by(series)
      x <- RTL::returns(df = x,retType = "abs",period.return = 1,spread = TRUE)
      x <- RTL::rolladjust(x = x,commodityname = r$cmdty,rolltype = c("Last.Trade"))
      x <- x %>% dplyr::filter(!grepl("2020-04-20|2020-04-21",date))
      browser()
      promptBeta(x = x,period = "all",betatype = "all",output = "chart")
      })

    output$betasAll <- renderPlot({
      shinipsum::random_ggplot()
    })

    output$betasSelected <- renderPlot({
      shinipsum::random_ggplot()
    })

  })
}

## To be copied in the UI
# mod_Betas_ui("Betas_ui_1")

## To be copied in the server
# mod_Betas_server("Betas_ui_1")
