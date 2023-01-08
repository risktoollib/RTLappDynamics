#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom bslib bs_theme font_google
#' @noRd
app_ui <- function(request) {
  shiny::fluidPage(
    # if you want to use bootstrap 5 styling
    theme = bslib::bs_theme(version = 5,
                            bg = "#333333", # 626C70
                            fg = "White",
                            primary = "Cyan",
                            heading_font = bslib::font_google("Prompt"),
                            base_font = bslib::font_google("Prompt"),
                            code_font = bslib::font_google("JetBrains Mono"),
                            "progress-bar-bg" = "lime"),
    # Leave this function for adding external resources
    golem_add_external_resources(),
    #<img src="https://i.imgur.com/XqpQZwi.png" width=300 />
    # UI logic
    titlePanel("Commodities Pricing Dynamics"),
    tags$h5(
      tags$span(style = "color:white;;font-size:0.8em;font-style:italic", "created by pcote@ualberta.ca"),
      tags$a(href = "https://www.linkedin.com/in/philippe-cote-88b1769/", icon("linkedin", "My Profile", target = "_blank")),
      tags$span(style = "color:#333333"," "),
      tags$span(style = "color:white;font-size:0.8em;font-style:italic", "data from "),
      tags$a(
        href = "https://commodities.morningstar.com/#/",
        tags$img(
          src = "https://commodities.morningstar.com/img/Mstar-logo-50px.e8433154.svg",
          title = "Morningstar Commodities",
          width = "100",
          height = "30"
        )
      )
    ),
    mod_contract_ui("contract_ui_1"),
    tags$h5(tags$span(style = "color:cyan;font-size:0.7em", "units are $/bbl for oil & products, $/mmBtu for NG.")),
    shiny::tabsetPanel(
     type = "tabs",
     shiny::tabPanel("Forward Curve", mod_CurveDynamics_ui("CurveDynamics_ui_1")),
     shiny::tabPanel("Seasonality", mod_Seasonality_ui("Seasonality_ui_1")),
     shiny::tabPanel("Volatility and Correlation", mod_VolCor_ui("VolCor_ui_1")),
     shiny::tabPanel("Betas", mod_Betas_ui("Betas_ui_1")),
     shiny::tabPanel("Spread Dynamics", mod_SpreadDynamics_ui("SpreadDynamics_ui_1"))
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

