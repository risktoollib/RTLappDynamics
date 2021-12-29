#' SpreadDynamics UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @rawNamespace import(plotly, except = last_plot)

mod_SpreadDynamics_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::column(
      12,
      tags$h3(tags$span(style = "color:blue", "Is Structure (c1c2) related to flat price?")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "A general relationship not useful for trading purposes.")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "What if you reframe the problem by making it conditional upon FP increases from each cyclical low?")),
      plotly::plotlyOutput(ns("structFlatPrice"), height = "600px"),
      tags$h3(tags$span(style = "color:blue", "Reframing the Problem as Capacity Utilization.")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "Imbalanced markets (close to operational tank tops or bottom) are where it matters.")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "Reframe the problem as capacity utilization.")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "Use analytics from this chart and predict where spreads should be based on your SD model for storage levels.")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "Then compare your results with the current forward curve and if different put a trade on!")),
      plotly::plotlyOutput(ns("structUtilization"), height = "600px"),
      tags$h3(tags$span(style = "color:blue", "Shape of intermonth spreads curve")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "Why do this? To get a perspective of how monthly time spreads reflect current imbalances in Supply-Demand balances.")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "When c1c2 moves in steep backwardation or contango, it is because of CURRENT imbalances.")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "Markets price the forward curve of intermonth spreads according to expectations with the information available TODAY.")),
      tags$h5(tags$span(style = "color:purple;font-style:italic", "Large dislocations in SD balances impact front spreads more as more time is available for supply and demand to re-establish a balance.")),
      shiny::radioButtons(ns("bucket"),
                          "Select width of c1c2 groups e.g. 0.25 will group between -0.125 to +0.125 into the 0 bucket:",
                          choices = seq(0.25,1,0.25),
                          selected = 0.5, inline = TRUE),
      plotly::plotlyOutput(ns("meanIntraMonthSruct"), height = "600px")
    )
  )
}

#' SpreadDynamics Server Functions
#'
#' @noRd
mod_SpreadDynamics_server <- function(id, r){
  moduleServer( id, function(input, output, session){

    ns <- session$ns

    c1c2 <- c1c6 <- capacity <- fp <- fpChange <- product <- series <- stocks <- value <- NULL

    output$structFlatPrice <- plotly::renderPlotly({
      r$spdDynamics %>%
        dplyr::mutate(year = lubridate::year(date)) %>%
        plotly::plot_ly(
          x = ~c1c2 ,
          y = ~fp,
          #name = ~ series,
          color = ~year,
          type = "scatter",
          mode = "markers"
        ) %>%
        plotly::layout(
          title = list(text = "Front Spread Market Structure and Flat Price", x = 0),
          xaxis = list(title = "Front Spread Structure", tickformat = "$.1f"),
          yaxis = list(title = "Flat Price", tickformat = "$.0f")
        )
    })

    output$structUtilization <- plotly::renderPlotly({
      #shiny::validate(shiny::need(r$contract %in% c("CL","HO","RB"), message = FALSE))

      if (r$contract == "CL") {
        tmp <- rbind(RTL::eiaStocks %>% dplyr::filter(series == "CrudeCushing"),
                     RTL::eiaStorageCap %>% dplyr::filter(series == "Cushing") %>% dplyr::select(-product))
      }

      if (r$contract == "RB") {
        tmp <- rbind(RTL::eiaStocks %>% dplyr::filter(series == "Gasoline"),
                     RTL::eiaStorageCap %>% dplyr::filter(product == "gasoline") %>% dplyr::select(-product))
      }

      if (r$contract == "HO") {
        tmp <- rbind(RTL::eiaStocks %>% dplyr::filter(series == "ULSD"),
                     RTL::eiaStorageCap %>% dplyr::filter(product == "distillates") %>% dplyr::select(-product))
      }

      if (r$contract == "NG") {
        tmp <- rbind(RTL::eiaStocks %>% dplyr::filter(series == "NGLower48"),
                     RTL::eiaStorageCap %>% dplyr::filter(product == "ng") %>% dplyr::select(-product))
      }

      tmp %>%
        tidyr::pivot_wider(names_from = series, values_from = value) %>%
        dplyr::arrange(date) %>%
        dplyr::rename(stocks = 2, capacity = 3) %>%
        tidyr::fill(capacity) %>%
        tidyr::drop_na() %>%
        dplyr::mutate(utilization = stocks / capacity,
                      year = lubridate::year(date)) %>%
        dplyr::left_join(r$spdDynamics %>% dplyr::select(date, c1c2)) %>%
        tidyr::drop_na() %>%
        plotly::plot_ly(
          x = ~c1c2 ,
          y = ~utilization,
          #name = ~ series,
          color = ~year,
          type = "scatter",
          mode = "markers"
        ) %>%
        plotly::layout(
          title = list(text = "Front Spread Market Structure vs Storage Utlization", x = 0),
          xaxis = list(title = "Front Spread Structure", tickformat = "$.1f"),
          yaxis = list(title = "Cushing Storage Utilization", tickformat = ".0%")
        )
    })

    output$meanIntraMonthSruct <- plotly::renderPlotly({
      bucket <- as.numeric(input$bucket)
      r$spdDynamics %>%
        dplyr::select(-fp, -fpChange,-c1c6) %>%
        dplyr::mutate(bucket = round(c1c2 / bucket) * bucket) %>%
        tidyr::pivot_longer(cols = c(-date,-bucket), names_to = "series", values_to = "value") %>%
        dplyr::group_by(bucket,series) %>%
        dplyr::summarise(value = mean(value), .groups = "drop") %>%
        #dplyr::mutate(series = forcats::fct_relevel(series,"c1c2","c2c3","c3c4","c4c5","c5c6")) %>%
        plotly::plot_ly(
          x = ~series ,
          y = ~value,
          name = ~bucket,
          #color = ~bucket,
          type = "scatter",
          mode = "lines+markers"
        ) %>%
        plotly::layout(
          title = list(text = "Average Intermonth Spread Structure by c1c2 Bucketed Levels", x = 0),
          xaxis = list(title = "Front Spreads"),
          yaxis = list(title = "c1c2 bucketed levels", tickformat = "$.2f")
        )
    })
  })
}

## To be copied in the UI
# mod_SpreadDynamics_ui("SpreadDynamics_ui_1")

## To be copied in the server
# mod_SpreadDynamics_server("SpreadDynamics_ui_1")
