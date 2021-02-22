.logs <- new.env()
.logs$log <- data.frame(
  what = character(0),
  time = character(0),
  stringsAsFactors = FALSE
)


#' #' Create data / listeners
#' #'

#' #' @return An environment.
#' #' @rdname new
#' #' @export
#' #' @importFrom shiny reactiveVal
#' new_data <- function(...){
#'   e <- new.env(parent = emptyenv())
#'   l <- list(...)
#'   mapply(function(x, y){
#'     e[[ y ]] <- x
#'   }, x = l, y = names(l))
#'   e
#' }

#' Handle logs
#'
#' Get / Clear the logs of all the time the `trigger()` functions are launched.
#'
#' @return a data.frame
#' @export
#' @rdname logs
get_gargoyle_logs <- function(){
  return(.logs$log)
}
#' @export
#' @rdname logs
clear_gargoyle_logs <- function(){
  .logs$log <- data.frame(
    what = character(0),
    time = character(0),
    stringsAsFactors = FALSE
  )
}
