#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  shiny::fluidPage(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # UI logic
    titlePanel("Commodities Pricing Dynamics"),
    tags$h5(tags$span(style = "color:blue;font-style:italic", "Developed by pcote@ualberta.ca for University of Alberta Finance classes.")),
    tags$h5(tags$span(style = "color:orange", "Units are $/bbl for oil & products, $/mmBtu for NG.")),
    shiny::radioButtons("contract","Select Contract",choices = unique(gsub(pattern = "[0-9]+",replacement = "",x = RTL::dflong$series))[1:6],selected = "BRN", inline = TRUE),
    shiny::tabsetPanel(
     type = "tabs",
     shiny::tabPanel("Forward Curve",
                     mod_CurveDynamics_ui("CurveDynamics_ui_1")),
     shiny::tabPanel("Volatility and Correlation",
                     mod_VolCor_ui("VolCor_ui_1")),
     shiny::tabPanel("Betas",
                     mod_Betas_ui("Betas_ui_1")),
     shiny::tabPanel("Spread Dynamics",
                     mod_SpreadDynamics_ui("SpreadDynamics_ui_1"))
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(ext = 'png'),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'RTLappDynamics'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

