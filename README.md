
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

`{gargoyle}` is a package that provides wrappers around some Shiny
elements to turn your app into and event-based application instead of a
full reactive app. The framework is centered around `listen` / `trigger`
and `on`.

It works with classical UI, and just needs tweaking the server side of
your app.

### What the heck?

Shiny’s default reactive behavior is very helpful when it comes to
building small applications. Because, you know, the good thing about
reactivity is that when something moves somewhere, it’s updated
everywhere. But the bad thing about reactivity is that when something
moves somewhere, it’s updated everywhere. So it does work pretty well on
small apps, but can get very complicated on bigger apps, and can quickly
get out of hands.

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

  - `init`, `listen` & `trigger`, which allow to initiate, listen on,
    and trigger an event

  - `on`, that runs the `expr` when the event in triggered

## Example

``` r
library(shiny)
library(gargoyle)
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
```

You can then get / clear the logs of the times the triggers were called:

``` r
get_gargoyle_logs()
clear_gargoyle_logs()
```

<br>

Please note that the ‘gargoyle’ project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
