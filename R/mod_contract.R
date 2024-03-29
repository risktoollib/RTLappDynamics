#' contract UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param r a list returning reactiveValues given the choice of contract.
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import RTL
#' @import dplyr
#' @import tidyr

mod_contract_ui <- function(id){
  ns <- NS(id)
  cc <- c("CL","NG","HO","RB")
  tagList(
    shiny::radioButtons(ns("contract"),"Select Contract",choices = cc, selected = "CL", inline = TRUE),
  )
}

#' contract Server Functions
#'
#' @noRd
mod_contract_server <- function(id, r) {
  moduleServer(id,
               function(input, output, session) {
                 shiny::observeEvent(input$contract, {

                   # assigns selected contract code
                   r$contract <- input$contract

                   # avoid no visible bindings for local vars
                   dflong <- series <- value <- c1c2 <- fp <- . <- x <- tmp <- NULL

                   # assigns computed datLong and datWide
                   x <- RTL::dfwide %>%
                     dplyr::select(date, contains(input$contract)) %>%
                     tidyr::drop_na()
                   #dplyr::filter(grepl(input$contract, series)) %>%
                   #tidyr::pivot_wider(names_from = series, values_from = value) %>%
                   #dplyr::select_if(~ !any(is.na(.)))
                   x <- x %>%
                     tidyr::pivot_longer(-date, names_to = "series", values_to = "value") %>%
                     dplyr::mutate(value = case_when(
                       grepl("HO", series) ~ value * 42,
                       grepl("RB", series) ~ value * 42,
                       TRUE ~ value
                     ))
                   if (input$contract == "CL") {
                     x <- x %>% dplyr::filter(date != "2020-04-20")
                   }

                   r$datLong <- x
                   r$datWide <- x %>% tidyr::pivot_wider(names_from = series,values_from = value)

                   # assigns cmdty for RTL::expiry_table
                   if (input$contract == "CL") {r$cmdty <- "cmewti"}
                   if (input$contract == "HO") {r$cmdty <- "cmeulsd"}
                   if (input$contract == "RB") {r$cmdty <- "cmerbob"}
                   if (input$contract == "NG") {r$cmdty <- "cmeng"}
                   if (input$contract == "BRN") {r$cmdty <- "cmebrent"}
                   if (input$contract == "ALI") {r$cmdty <- "comexalu"}
                   if (input$contract == "WCW") {r$cmdty <- "cmewti"}

                   # assigns computed retWide log returns
                   tmp <-
                     RTL::returns(
                       df = r$datLong,
                       retType = "rel",
                       period.return = 1,
                       spread = TRUE
                     )
                   r$retWide <- RTL::rolladjust(
                     x = tmp,
                     commodityname = r$cmdty,
                     rolltype = c("Last.Trade")
                   )

                   # assigns computed retWide Absolute returns
                   tmp <-
                     RTL::returns(
                       df = r$datLong,
                       retType = "abs",
                       period.return = 1,
                       spread = TRUE
                     )
                   r$retWideAbs <- RTL::rolladjust(
                     x = tmp,
                     commodityname = r$cmdty,
                     rolltype = c("Last.Trade")
                   )

                   # assigns computed spdDynamics
                   tmp <- r$datWide %>%
                     dplyr::transmute(
                       date,
                       fp = .[[2]],
                       fpChange = .[[2]] - dplyr::lag(.[[2]], n = 1),
                       c1c2 = .[[2]] - .[[3]],
                       c2c3 = .[[3]] - .[[4]],
                       c3c4 = .[[4]] - .[[5]],
                       c4c5 = .[[5]] - .[[6]],
                       c5c6 = .[[6]] - .[[7]],
                       c1c6 = .[[2]] - .[[7]]
                     ) %>% tidyr::drop_na()
                   tmp <- RTL::rolladjust(x = tmp,commodityname = r$cmdty,rolltype = c("Last.Trade"))
                   if (r$cmdty == "cmewti") { tmp <- tmp %>% dplyr::filter(fp > 0, abs(c1c2) < 10)}
                   r$spdDynamics <- tmp

                   # assigns data for RTL::promptBeta in Betas tab
                   betas <- r$datLong %>% dplyr::mutate(series = readr::parse_number(series)) %>% dplyr::group_by(series)
                   betas <- RTL::returns(df = betas,retType = "abs",period.return = 1,spread = TRUE)
                   betas <- RTL::rolladjust(x = betas,commodityname = r$cmdty,rolltype = c("Last.Trade"))
                   r$betas <- betas %>% dplyr::filter(!grepl("2020-04-20|2020-04-21",date))

                   # assigns data for eia storage levels

                   if (r$contract == "CL") {r$stocks <- RTL::eiaStocks %>% dplyr::filter(series == "CrudeCushing")}
                   if (r$contract == "RB") {r$stocks <- RTL::eiaStocks %>% dplyr::filter(series == "Gasoline")}
                   if (r$contract == "HO") {r$stocks <- RTL::eiaStocks %>% dplyr::filter(series == "ULSD")}
                   if (r$contract == "NG") {r$stocks <- RTL::eiaStocks %>% dplyr::filter(series == "NGLower48")}

                   r$stocks <- r$stocks %>% dplyr::ungroup() %>% dplyr::select(-series)
                   # assigns tsi object for seasonality server outputs

                   seasonDat <- tsi <- series <- value <- NULL
                   seasonDat <- dplyr::inner_join(r$stocks %>% dplyr::select(-series),
                                                  r$datWide %>% dplyr::select(1:2),
                                                  by = join_by(date)) %>%
                     dplyr::rename(stocks = value, price = 3) %>%
                     dplyr::ungroup() %>%
                     dplyr::select(-series) %>%
                     tidyr::pivot_longer(-date, names_to = "series",values_to = "value")

                   r$tsi <- seasonDat %>%
                     tsibble::as_tsibble(key = series, index = date) %>%
                     tsibble::group_by_key() %>%
                     tsibble::index_by(freq = ~ tsibble::yearmonth(.)) %>%
                     dplyr::summarise(value = mean(value), .groups = c("keep")) %>%
                     tsibble::fill_gaps()

                 })
               })
}

## To be copied in the UI
# mod_contract_ui("contract_ui_1")

## To be copied in the server
# mod_contract_server("contract_ui_1")
