library(shiny)

ui <- function(request){
  tagList(
    h4('Trigger y'),
    actionButton("y", "y"),
    h4('Trigger z'),
    actionButton("z", "z"),
    h4('Print change only triggered by y:'),
    verbatimTextOutput("evt")
  )
}

server <- function(input, output, session){

  x <- new_data( event = 0 )

  f <- new_listeners("y", "z", "a")

  observeEvent( input$y , {
    # Will trigger the UI change
    # And the print below
    x$event <- x$event + 1
    print(x$event)
    trigger(f$y)
  })

  output$evt <- renderPrint({
    listen(f$y)
    x$event
  })

  observeEvent( input$z , {
    # This won't update the
    # renderPrint
    x$event <- x$event + 1
    print(x$event)
    trigger(f$a)
  })

  # Example of chaining triggers
  on( f$a , {
    print("f$a")
    # This won't trigger the renderPrint
    x$this <- runif(10)
    trigger(f$z)
  })

  on( f$z , {
    print("f$z")
    print(x$this)
  })

}

shinyApp(ui, server)
