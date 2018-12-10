#' @title Start mlrPlayground app
#'
#' @description
#' Run a local instance of mlrPlayground
#'
#' @param ... [\code{any}]\cr
#'   Additional arguments passed to shiny's
#'   \code{runApp()} function.
#' @examples
#' \dontrun{
#'   start()
#' }
#' @export

start = function(...) {
  appDir = system.file("R", package = "mlrPlayground")

  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `mlrPlayground`.", call. = FALSE)
  }

  shiny::runApp(appDir)
}
