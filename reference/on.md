# React on an event

React on an event

## Usage

``` r
on(name, expr, session = getDefaultReactiveDomain())
```

## Arguments

- name:

  the name of the event to react to

- expr:

  the expression to run when the event is triggered.

- session:

  The shiny session object

## Value

An observeEvent object. This object will rarely be used, \`on\` is
mainly called for side-effects.
