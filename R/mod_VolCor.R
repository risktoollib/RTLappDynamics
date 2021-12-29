#' VolCor UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @import ggplot2
#' @importFrom shiny NS tagList
#' @importFrom stats sd
#' @importFrom scales label_percent
#' @importFrom zoo index coredata
#' @rawNamespace import(plotly, except = last_plot)

mod_VolCor_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::column(12,
                  tags$h3(tags$span(style = "color:blue", "Volatility is a function of Delivery Timing")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "Why would think so in the context of economics?")),
                  shiny::plotOutput(ns("volByDelivery")),
                  plotly::plotlyOutput(ns("volBoxplot")),
                  tags$h3(tags$span(style = "color:blue", "Volatility is NOT constant through time")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "What measure of RISK are you using to proxy UNCERTAINTY?")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "What implications does it have for your analysis?")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "What if you are using VaR with a 60-day window (sdroll in the chart)")),
                  plotly::plotlyOutput(ns("volMeasures")),
                  tags$h3(tags$span(style = "color:blue", "Introducing Correlation")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "Same grade, same delivery location, DIFFERENT delivery timing = Same information set.")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "Correlation only informs the DIRECTIONAL relationship.")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "Beware of using continuous contracts in seasonal commodities... Why?")),
                  tags$h5(tags$span(style = "color:purple;font-style:italic", "So what are the implications for spread trading? NEXT TAB")),
                  shiny::plotOutput(ns("correlation"), height = "600px")
    )
  )
}

#' VolCor Server Functions
#'
#' @noRd
mod_VolCor_server <- function(id, r) {
  moduleServer(id,
               function(input, output, session) {
                 #ns <- session$ns # WHY WE DON'T NEED THIS ANYMORE

                 output$volByDelivery <- renderPlot({
                   # global visible variables instantiation
                   tmp <- lims <- series <- value <- stddev <- NULL
                   tmp <- r$retWide
                   sd.simple <- tmp %>%
                     tidyr::pivot_longer(-date, names_to = "series", values_to = "value") %>%
                     dplyr::group_by(series) %>%
                     dplyr::summarize(stddev = sd(value) * sqrt(252),
                                      .groups = "keep")
                   sd.simple %>%
                     ggplot(aes(x = series, y = stddev)) + geom_point(col = "blue") +
                     theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
                     scale_y_continuous(labels = scales::label_percent()) +
                     labs(title = "Annualized Historical Volatility By Delivery Timing",
                          x = "")
                 })
                 output$volBoxplot <- plotly::renderPlotly({
                   tmp <- r$retWide
                   lims <- (max(abs(tmp[, -1])) %/% 0.05 + 1) * 0.05
                   tmp %>%
                     tidyr::pivot_longer(-date, "series", "value") %>%
                     plotly::plot_ly(
                       y = ~ value,
                       color = ~ series,
                       type = "box",
                       colors = c("blue", "orange")
                     )  %>%
                     plotly::layout(
                       title = list(text = "Volatility Decreases with Delivery Timing", x = 0),
                       xaxis = list(title = ""),
                       yaxis = list(
                         title = "Daily Returns",
                         separators = '.,',
                         tickformat = ".0%",
                         range = c(-lims, lims)
                       )
                     )
                 })
                 output$volMeasures <- plotly::renderPlotly({
                   sd.simple <-
                     tmplong <- sdroll <- sd.roll <- vol.garch <- sd.garch <- NULL

                   tmp <- r$retWide[, 1:2]
                   sd.simple <- sd(tmp[, 2][[1]]) * sqrt(252)
                   tmplong <-
                     tmp %>% tidyr::pivot_longer(-date, names_to = "series", values_to = "value")
                   sdroll <- tibbletime::rollify(stats::sd, window = 60)
                   sd.roll <- tibbletime::as_tbl_time(tmplong, index = date) %>%
                     dplyr::group_by(series) %>%
                     dplyr::mutate(sdRoll = sdroll(value) * sqrt(252)) %>%
                     dplyr::ungroup() %>% tidyr::drop_na()

                   vol.garch <- RTL::garch(x = tmp, out = "data")
                   sd.garch <-
                     data.frame(date = zoo::index(vol.garch), zoo::coredata(vol.garch)) %>%
                     dplyr::select(-returns)
                   merge(
                     sd.roll %>% dplyr::select(-series,-value) %>% dplyr::mutate(sd = sd.simple),
                     sd.garch
                   ) %>%
                     tidyr::pivot_longer(cols = -date,
                                         names_to = "series",
                                         values_to = "value") %>%
                     plotly::plot_ly(
                       x = ~ date,
                       y = ~ value,
                       name = ~ series,
                       color = ~ series
                     ) %>%
                     plotly::add_lines() %>%
                     plotly::layout(
                       title = list(text = "", x = 0),
                       xaxis = list(title = ""),
                       yaxis = list(title = "Annualized Volality", tickformat = ".0%")
                     )
                 })
                 output$correlation <- renderPlot({
                   tmp <- r$retWide %>% timetk::tk_xts(rename_index = "date")
                   PerformanceAnalytics::chart.Correlation(tmp[, 1:6])
                 })

               })
}

## To be copied in the UI
# mod_VolCor_ui("VolCor_ui_1")

## To be copied in the server
# mod_VolCor_server("VolCor_ui_1")
