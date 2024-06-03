#' Initiate, trigger, event
#'
#' @param name,... The name(s) of the events
#' @param session The shiny session object
#'
#' @rdname Event
#'
#' @return The `session` object invisibly.
#' These functions are mainly used for side-effects.
#'
#' @importFrom shiny reactiveVal
#' @export
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(gargoyle)
#'   options("gargoyle.talkative" = TRUE)
#'   ui <- function(request) {
#'     tagList(
#'       h4("Go"),
#'       actionButton("y", "y"),
#'       h4("Output of z$v"),
#'       tableOutput("evt")
#'     )
#'   }
#'
#'   server <- function(input, output, session) {
#'     # Initiating the flags
#'     init("airquality", "iris", "renderiris")
#'
#'     # Creating a new env to store values, instead of
#'     # a reactive structure
#'     z <- new.env()
#'
#'     observeEvent(input$y, {
#'       z$v <- mtcars
#'       # Triggering the flag
#'       trigger("airquality")
#'     })
#'
#'     on("airquality", {
#'       # Triggering the flag
#'       z$v <- airquality
#'       trigger("iris")
#'     })
#'
#'     on("iris", {
#'       # Triggering the flag
#'       z$v <- iris
#'       trigger("renderiris")
#'     })
#'
#'     output$evt <- renderTable({
#'       # This part will only render when the renderiris
#'       # flag is triggered
#'       watch("renderiris")
#'       head(z$v)
#'     })
#'   }
#'
#'   shinyApp(ui, server)
#' }
init <- function(..., session = getDefaultReactiveDomain()) {
  lapply(
    list(...),
    function(x) {
      session$userData[[x]] <- reactiveVal(0)
    }
  )
}

#' @rdname Event
#' @export
trigger <- function(..., session = getDefaultReactiveDomain()) {
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
    function(x) {
      if (getOption("gargoyle.talkative", FALSE)) {
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
watch <- function(name, session = getDefaultReactiveDomain()) {
  session$userData[[name]]()
}

#' React on an event
#'
#' @param name The name of the event to react to as a character; can be a
#'   character vector of event names in which case a reaction is triggered if
#'   any (all) of the events is (are) triggered (i.e. the non-exclusive "OR"
#'   case).
#' @param expr The expression to run when the event is triggered.
#' @param session The shiny session object.
#'
#' @return An [shiny::observeEvent()] object. This object will
#' rarely be used, `on` is mainly called for side-effects.
#'
#' @export
#' @importFrom shiny observeEvent getDefaultReactiveDomain
#' @importFrom attempt stop_if_not
on <- function(
  name,
  expr,
  session = getDefaultReactiveDomain()
    ) {
  stop_if_not(
    all(name %in% names(session$userData)),
    msg = sprintf(
      "[Gargoyle] Flag %s hasn't been initiated: can't listen to it.\n",
      name[!(name %in% names(session$userData))]
    )
  )
  watch_expr <- generate_watch_expr(name)
  observeEvent(
    do.call("substitute", list(watch_expr[[1]])),
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
generate_watch_expr <- function(name) {
  if (length(name) > 1) {
    tmp_expr <- parse(
      text = paste0(
        "list(",
        paste0(
          "gargoyle::watch(name[",
          seq_along(name),
          "], session = session)",
          collapse = ", "
        ),
        ")"
      )
    )
  } else {
    tmp_expr <- parse(text = "gargoyle::watch(name, session = session)")
  }
  return(tmp_expr)
}
