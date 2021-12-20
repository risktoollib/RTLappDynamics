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
    titlePanel("Forward Curve Pricing Dynamics"),
    tags$h5(tags$span(style = "color:blue;font-style:italic", "developed by pcote@ualberta.ca for Commodity Analytics and Trading classes.")),
    tags$h5(tags$span(style = "color:orange", "Units are $/bbl for oil & products, $/mmBtu for NG.")),
    shiny::tabsetPanel(
     type = "tabs",
     shiny::tabPanel("Forward Curve",
              shiny::column(12,
                     tags$h3(tags$span(style = "color:blue;font-style:italic", "...form your hypotheses of the pricing dynamics...")),
                     tags$h5(tags$span(style = "color:purple;font-style:italic", "+ Root your thinking on fundamentals (SD Balance and the physical supply chain)")),
                     tags$h5(tags$span(style = "color:purple;font-style:italic", "+ Forward prices are the expected spot price with today's information set.")),
                     tags$h5(tags$span(style = "color:purple;font-style:italic", "+ What can you infer from the volality of the front contract?")),
                     tags$h5(tags$span(style = "color:purple;font-style:italic", "+ How is the forward curve moving along with flat price and why?")),
                     tags$h5(tags$span(style = "color:purple;font-style:italic", "+ ...")),
                     mod_CurveDynamics_ui("CurveDynamics_ui_1"))
              ),

     shiny::tabPanel(
       "Volatility and Correlation",
       shiny::column(12,
         tags$h3(tags$span(style = "color:blue", "Volatility is a function of Delivery Timing")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "Why would think so in the context of economics?")),
         mod_VolCor_ui("VolCor_ui_1"),
         mod_VolCor_ui("VolCor_ui_2"),
         #plotOutput("vol1", height = "400px"),
         #plotly::plotlyOutput("vol2", height = "400px"),
         tags$h3(tags$span(style = "color:blue", "Volatility is NOT constant through time")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "What measure of risk are you using to proxy uncertainty?")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "What implications does it have for your analysis?")),
         #numericInput("window","Select # days for a rolling standard deviation:",
        #              value = 60, min = 20,step = 10, width = "600px"),
         mod_VolCor_ui("VolCor_ui_3"),
         #plotly::plotlyOutput("volInTime", height = "400px"),
         tags$h3(tags$span(style = "color:blue", "Introducing Correlation")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "Same grade, same delivery location, DIFFERENT delivery timing = Same information set.")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "Correlation only informs the DIRECTIONAL relationship.")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "So what are the implications for spread trading? NEXT TAB")),
         #plotOutput("correlation", height = "600px"),
         mod_VolCor_ui("VolCor_ui_4")
       )
     ),
     shiny::tabPanel(
       "Betas",
       shiny::column(12,
         tags$h3(tags$span(style = "color:blue", "Hedge Ratios of Contracts vs Front Contract")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "Time spreads are a function of correlation times the ratio of volatility")),
         mod_Betas_ui("Betas_ui_1"),
         #plotly::plotlyOutput("betasChart"),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "See how they change through time.")),
         #numericInput("days","Select Last Number of Days to Compare Betas with Lon Run fits:",
        #              value = 100, min = 60, width = "600px"),
        shiny::column(6,
                tags$h3(tags$span(style = "color:blue","Betas - All History ")),
                mod_Betas_ui("Betas_ui_2")
                #tableOutput("betas")
         ),
        shiny::column(6,
                tags$h3(tags$span(style = "color:blue","Betas - Recent Selected Days")),
                mod_Betas_ui("Betas_ui_3")
                #tableOutput("betasRecent")
         )
       )
     ),
     shiny::tabPanel(
       "Spread Dynamics",
       shiny::column(
         12,
         tags$h3(tags$span(style = "color:blue", "Is Structure (c1c2) related to flat price?")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "A general relationship not useful for trading purposes.")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "What if you reframe the problem by making it conditional upon FP increases from each cyclical low?")),
         mod_SpreadDynamics_ui("SpreadDynamics_ui_1"),
         #plotly::plotlyOutput("spdFP", height = "600px"),
         tags$h3(tags$span(style = "color:blue", "Reframe the Problem as Capacity Utilization (CL, HO & RB only)")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "Imbalanced markets (close to operational tank tops or bottom) are where it matters.")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "Reframe the problem as capacity utilization.")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "Use analytics from this chart and predict where spreads should be based on your SD model for storage levels.")),
         tags$h5(tags$span(style = "color:purple;font-style:italic", "Then compare your results with the current forward curve and if different put a trade on!")),
         mod_SpreadDynamics_ui("SpreadDynamics_ui_2"),
         #plotly::plotlyOutput("spdUtil", height = "600px"),
         tags$h3(tags$span(style = "color:blue", "Shape of intermonth spread curve")),
         mod_SpreadDynamics_ui("SpreadDynamics_ui_3")
         #numericInput("bucket","Select width of c1c2 groups e.g. 0.25 will group between -0.125 to +0.125 into the 0 bucket:",
        #              value = 0.50, min = 0.25, step = 0.25,width = "800px"),
         #plotly::plotlyOutput("spdDyn", height = "600px")
       )
     )
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

