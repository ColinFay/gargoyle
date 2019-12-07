ui <- function(request){
  tagList(
    h4('Go'),
    actionButton("y", "y"),
    h4('Output of z$v'),
    tableOutput("evt")
  )
}

server <- function(input, output, session){

  init( "plop", "pouet", "poum")

  z <- new.env()

  observeEvent( input$y , {
    trigger("plop")
    z$v <- mtcars
  })

  on("plop", {
    z$v <- airquality
    trigger("pouet")
  })

  on("pouet", {
    z$v <- iris
    trigger("poum")
  })

  output$evt <- renderTable({
    watch("poum")
    head(z$v)
  })

}

shinyApp(ui, server)
