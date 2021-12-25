#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic
  mod_CurveDynamics_server("CurveDynamics_ui_1")
  mod_VolCor_server("VolCor_ui_1")
  mod_VolCor_server("VolCor_ui_2")
  mod_VolCor_server("VolCor_ui_3")
  mod_VolCor_server("VolCor_ui_4")
  mod_Betas_server("Betas_ui_1")
  mod_Betas_server("Betas_ui_2")
  mod_Betas_server("Betas_ui_3")
  mod_SpreadDynamics_server("SpreadDynamics_ui_1")
  mod_SpreadDynamics_server("SpreadDynamics_ui_2")
  mod_SpreadDynamics_server("SpreadDynamics_ui_3")
}
