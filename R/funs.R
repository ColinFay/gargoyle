#' Create data / listeners
#'
#' @param ... for data, a named list with name / value. For
#'     listeners, the names of the listeners.
#' @return An environment.
#' @rdname new
#' @export
#' @importFrom shiny reactiveVal
new_data <- function(...){
  e <- new.env(parent = emptyenv())
  l <- list(...)
  mapply(function(x, y){
    e[[ y ]] <- x
  }, x = l, y = names(l))
  e
}

#' @rdname new
#' @export
new_listeners <- function(...){
  e <- new.env(parent = emptyenv())
  lapply(list(...), function(x){
    e[[ x ]] <- reactiveVal(0)
  })
  e
}


#' Trigger/listen
#'
#' @param f The listener to trigger/listen
#'
#' @rdname Event
#' @export
trigger <- function(f){
  f( f() + 1 )
}

#' @rdname Event
#' @export
listen <- function(f){
  f()
}

#' React on an event
#'
#' @param f the event to react to
#' @param expr the expression to run when the event
#'     is triggered.
#'
#' @export
#' @importFrom shiny observeEvent
on <- function(f, expr){
  #browser()
  observeEvent(
    substitute(f()),
    {
      substitute(expr)
    },
    event.quoted = TRUE,
    handler.quoted = TRUE,
    ignoreInit = TRUE,
    event.env = parent.frame(),
    handler.env = parent.frame()
  )
}
