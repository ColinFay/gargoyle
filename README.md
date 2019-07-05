
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gargoyle

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

\[WIP\]

The goal of gargoyle is to provide a non-reactive, event-based framework
for Shiny.

## Installation

You can install the released version of gargoyle from
[Github](https://CRAN.R-project.org) with:

``` r
remotes::install_github("ColinFay/gargoyle")
```

## About

`{gargoyle}` is a package that provide an event-based framework for
building a shiny application. The paradigm is centered around `listen` /
`trigger` and `on`.

### What the heck?

Shiny’s default reactive behavior is very helpful when it comes to
building small applications. Because, you know, the good thing about
reactivity is that when something moves somewhere, it’s updated
everywhere. But the bad thing about reactivity is that when something
moves somewhere, it’s updated everywhere. The result being that where it
does work pretty well on small app, it can get very complicated to
handle on bigger apps, where reactive values get updated too much, not
when needed, or even loop from one to another. Cause let’s be honnest,
reactivity can quickly get out of hands.

That’s where `{gargoyle}` comes: it provides an event based paradigm for
building your apps, so that things happen under a control flow.

### For whom?

If you’re just building small shiny apps, you’re probably good with
Shiny default reactive behavior. But if ever you’ve struggled with
reactivity on more bigger apps, you might find `{gargoyle}` useful.

### The trade-off

`{gargoyle}` will be more verbose and will demand more work upfront to
make things happen. I believe this is for the best if you’re working on
a big project.

## Design pattern

A `{gargoyle}` has:

  - `new_data` & `new_listeners`, which contains values, and listeners

  - `listen` & `trigger`, which allow to listen on / trigger an event

  - `on`, that runs the `expr` when the event in triggered

## Example

``` r
library(shiny)
library(gargoyle)
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

  x <- new_data( event = 0)

  f <- new_listeners("y", "z", "a")

  observeEvent( input$y , {
    # Will trigger the UI change
    # And the print below
    x$event <- 1
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
    x$a <- runif(1)
    trigger(f$z)
  })

  on( f$z , {
    print("f$z")
    print(x$this)
    x$b <- runif(1)
  })

}

shinyApp(ui, server)
```

<br>

Please note that the ‘gargoyle’ project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
