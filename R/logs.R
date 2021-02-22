.logs <- new.env()
.logs$log <- data.frame(
  what = character(0),
  time = character(0),
  stringsAsFactors = FALSE
)

#' Handle logs
#'
#' Get / Clear the logs of all the time the `trigger()` functions are launched.
#'
#' @return a data.frame
#' @export
#' @rdname logs
#' @example
#' if (interactive()){
#'   get_gargoyle_logs()
#'   clear_gargoyle_logs()
#' }
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
