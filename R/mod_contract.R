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
  cc <- unique(gsub(pattern = "[0-9]+",replacement = "",x = RTL::dflong$series))[1:6]
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
                   dflong <- series <- value <- c1c2 <- fp <- . <- NULL

                   # assigns computed datLong
                   tmp <- RTL::dflong %>%
                     dplyr::mutate(value = case_when(
                       grepl("HO", series) ~ value * 42,
                       grepl("RB", series) ~ value * 42,
                       TRUE ~ value
                     )) %>%
                     dplyr::filter(grepl(input$contract, series))
                   if (input$contract == "CL") {
                     tmp <- tmp %>% dplyr::filter(date != "2020-04-20")
                   }
                   r$datLong <- tmp

                   # assigns computed datWide
                   r$datWide <- tmp %>%
                     dplyr::filter(grepl(input$contract, series)) %>%
                     tidyr::pivot_wider(names_from = series, values_from = value)

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
                 })
               })
}

## To be copied in the UI
# mod_contract_ui("contract_ui_1")

## To be copied in the server
# mod_contract_server("contract_ui_1")
