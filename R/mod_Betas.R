#' Betas UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @import RTL
#' @import shiny
#' @rawNamespace import(plotly, except = last_plot)

mod_Betas_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::column(12,
                  tags$h3(tags$span(style = "color:blue", "Hedge Ratios of Contract #n vs Front Contract")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "Hedge ratios are a function of correlation times the ratio of volatility")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "Notice how they differ when prices go up (bull) and down (bear).")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "Don't apply Finance or statistics without understanding its assumptions!")),
                  tags$h6(tags$span(style = "color:orange;font-style:italic", "+ Stationarity in its distribution properties.")),
                  tags$h6(tags$span(style = "color:orange;font-style:italic", "+ No STRUCTURAL changes during the period... a hard assumption to make in physical commodities.")),
                  plotly::plotlyOutput(ns("hedgeRatios")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "See how recent betas compare to all data available.")),
                  shiny::radioButtons(ns("days"),"Select recent # of trading days to compare with long term betas:",choices = c(20,60,120,250), selected = "60", inline = TRUE),
                  tags$h3(tags$span(style = "color:blue","Betas - Recent Trading Days")),
                  plotly::plotlyOutput(ns("betasCompare"))
                  )
  )
}

#' Betas Server Functions
#'
#' @noRd
mod_Betas_server <- function(id, r){
  moduleServer( id, function(input, output, session){

    ns <- session$ns # WHY WE DON'T NEED THIS ANYMORE
    contract <- NULL

    output$hedgeRatios <- plotly::renderPlotly({
      RTL::promptBeta(x = r$betas, period = "all", betatype = "all", output = "chart")
      })

    output$betasCompare <- plotly::renderPlotly({
      all <- RTL::promptBeta(x = r$betas, period = "all", betatype = "all", output = "betas")
      recent <- RTL::promptBeta(x = r$betas , period = as.character(input$days), betatype = "all", output = "betas")
      change <-  recent[,1:3] - all[,1:3]
      contracts <- all$contract
      change %>%
        dplyr::mutate(contract = contracts) %>%
        tidyr::pivot_longer(-contract, names_to = "series",values_to = "value") %>%
        plotly::plot_ly(x = ~contract, y = ~value, name = ~series, color = ~series) %>%
        plotly::add_lines() %>%
        plotly::layout(title = list(text = paste("Betas Difference between Selection and since",r$betas$date[1]), x = 0),
                       xaxis = list(title = "Contracts"),
                       yaxis = list(title = "Change in Betas"))
    })
  })
}

## To be copied in the UI
# mod_Betas_ui("Betas_ui_1")

## To be copied in the server
# mod_Betas_server("Betas_ui_1")
