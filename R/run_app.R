#' Shiny App
#'
#' @param ... no arguments required
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#' @return a Shiny application launching
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
#' @export

run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
