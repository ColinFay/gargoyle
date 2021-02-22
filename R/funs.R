#' Initiate, triger, event
#'
#' @param name,... The name(s) of the events
#' @param session The shiny session object
#'
#' @rdname Event
#' @importFrom shiny reactiveVal
#' @export
init <- function(..., session = getDefaultReactiveDomain()){
  lapply(
    list(...),
    function(x){
      session$userData[[x]] <- reactiveVal(0)
    }
  )

}

#' @rdname Event
#' @export
trigger <- function(..., session = getDefaultReactiveDomain()){
  .logs$log <- rbind(
    .logs$log,
    data.frame(
      what = c(...),
      time = as.character(Sys.time()),
      stringsAsFactors = FALSE
    )
  )
  lapply(
    list(...),
    function(x){
      if (getOption("gargoyle.talkative", FALSE)){
        cat(
          "- [Gargoyle] Triggering",
          x,
          "\n"
        )
      }
      session$userData[[x]](
        session$userData[[x]]() + 1
      )
    }
  )

}
#' @rdname Event
#' @export
watch <- function(name, session = getDefaultReactiveDomain()){
  session$userData[[name]]()
}


#' React on an event
#'
#' @param name the name of the event to react to
#' @param expr the expression to run when the event
#'     is triggered.
#' @param session The shiny session object
#'
#' @export
#' @importFrom shiny observeEvent getDefaultReactiveDomain
#' @importFrom attempt stop_if
on <- function(
  name,
  expr,
  session = getDefaultReactiveDomain()
  ){

  stop_if(
    session$userData[[name]],
    is.null,
    sprintf(
      "[Gargoyle] Flag %s hasn't been initiated: can't listen to it.",
      name
    )
  )
  observeEvent(
    substitute(watch(name)),
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
