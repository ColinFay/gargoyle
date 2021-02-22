## Test environments
* local R installation, R 3.6.1
* ubuntu 16.04 (on travis-ci), R 3.6.1
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 note

This is a resubmission after Uwe Ligges feedback 

>   Found the following (possibly) invalid URLs:
>      URL: https://www.tidyverse.org/lifecycle/#experimental (moved to
> https://lifecycle.r-lib.org/articles/stages.html)
>        From: README.md
>        Status: 200
>        Message: OK
> 
> Please change http --> https, add trailing slashes, or follow moved
> content as appropriate.

=> Link updated in Readme.md

>    Found the following (possibly) invalid file URI:
>      URI: CODE_OF_CONDUCT.md
>        From: README.md
> 
> Pls include the file, link via a fully specified URL or omit the link.

=> Link updated in Readme.md

=> Checked with `urlchecker::url_check()`
