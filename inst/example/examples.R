ui <- function(request){
  tagList(
    h4('Go'),
    actionButton("y", "y"),
    h4('Output of z$v'),
    tableOutput("evt")
  )
}

server <- function(input, output, session){

  # Initiating the flags
  init("airquality", "iris", "renderiris")

  # Creating a new env to store values, instead of
  # a reactive structure
  z <- new.env()

  observeEvent( input$y , {
    z$v <- mtcars
    # Triggering the flag
    trigger("airquality")
  })

  on("airquality", {
    # Triggering the flag
    z$v <- airquality
    trigger("iris")
  })

  on("iris", {
    # Triggering the flag
    z$v <- iris
    trigger("renderiris")
  })

  output$evt <- renderTable({
    # This part will only render when the renderiris
    # flag is triggered
    watch("renderiris")
    head(z$v)
  })

}

shinyApp(ui, server)
