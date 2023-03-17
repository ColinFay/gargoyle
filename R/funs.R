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
#' if (interactive()){
#'   library(shiny)
#'   library(gargoyle)
#'   options("gargoyle.talkative" = TRUE)
#'   ui <- function(request){
#'     tagList(
#'       h4('Go'),
#'       actionButton("y", "y"),
#'       h4('Output of z$v'),
#'       tableOutput("evt")
#'     )
#'   }
#'
#'   server <- function(input, output, session){
#'
#'     # Initiating the flags
#'     init( "plop", "pouet", "poum")
#'
#'     # Creating a new env to store values, instead of
#'     # a reactive structure
#'     z <- new.env()
#'
#'     observeEvent( input$y , {
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
#'
#'   }
#'
#'   shinyApp(ui, server)
#'
#' }
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
#' @return An observeEvent object. This object will
#' rarely be used, `on` is mainly called for side-effects.
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
    substitute(gargoyle::watch(name)),
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
