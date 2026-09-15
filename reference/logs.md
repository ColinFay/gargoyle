# Handle logs

Get / Clear the logs of all the time the \`trigger()\` functions are
launched.

## Usage

``` r
get_gargoyle_logs()

clear_gargoyle_logs()
```

## Value

A data.frame of the logs.

## Examples

``` r
if (interactive()){
  get_gargoyle_logs()
  clear_gargoyle_logs()
}
```
