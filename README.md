
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gargoyle

<!-- badges: start -->

[![R-CMD-check](https://github.com/ColinFay/gargoyle/workflows/R-CMD-check/badge.svg)](https://github.com/ColinFay/gargoyle/actions)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable/)
<!-- badges: end -->

The goal of gargoyle is to provide an event-based mechanism for
`{shiny}`.

## Installation

You can install the dev version of `{gargoyle}` with:

``` r
remotes::install_github("ColinFay/gargoyle")
```

## About

`{gargoyle}` is a package that provides wrappers around `{shiny}` to
turn your app into and event-based application instead of a full
reactive app. The framework is centered around a `listen` & `trigger`
mechanism.

It works with classical UI, and just needs tweaking the server side of
your app.

### What the heck?

`{shiny}`’s default reactive behavior is very helpful when it comes to
building small applications. Because, you know, the good thing about
reactivity is that when something moves somewhere, it’s updated
everywhere. But the bad thing about reactivity is that when something
moves somewhere, it’s updated everywhere. So it does work pretty well on
small apps, but can get very complicated on bigger apps, and can quickly
get out of hands.

That’s where `{gargoyle}` comes into play: it provides an event based
paradigm for building your apps, so that things happen under a control
flow.

### For whom?

If you’re just building small `{shiny}` apps, you’re probably good with
`{shiny}` default reactive behavior. But if ever you’ve struggled with
reactivity on more bigger apps, you might find `{gargoyle}` useful.

### The trade-off

`{gargoyle}` will be more verbose and will demand more work upfront to
make things happen. I believe this is for the best if you’re working on
a big project.

## Design pattern

`{gargoyle}` has:

  - `init`, `listen` & `trigger`, which allow to initiate, listen on,
    and trigger an event

  - `on`, that runs the `expr` when the event in triggered

`gargoyle::trigger()` can print messages to the console using
`options("gargoyle.talkative" = TRUE)`.

## Example

``` r
library(shiny)
library(gargoyle)
options("gargoyle.talkative" = TRUE)
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
  init( "plop", "pouet", "poum")
  
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
```

You can then get & clear the logs of the times the triggers were called:

``` r
get_gargoyle_logs()
clear_gargoyle_logs()
```

<br>

## Code of Conduct

Please note that the gargoyle project is released with a [Contributor
Code of
Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/).
By contributing to this project, you agree to abide by its terms.
