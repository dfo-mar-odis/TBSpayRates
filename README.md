
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TBSpayRates

<!-- badges: start -->

[![R-CMD-check](https://github.com/dfo-mar-odis/TBSpayRates/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dfo-mar-odis/TBSpayRates/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of TBSpayRates is to extract rates of pay for public servants
from the Treasury Board of Canada Secretariat and tools for project
planning/salary forecasting.

## Installation

You can install the development version of TBSpayRates from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("dfo-mar-odis/TBSpayRates")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(TBSpayRates)

SP_salaries <- get_salaries("SP")
#> Warning: There was 1 warning in `dplyr::mutate()`.
#> ℹ In argument: `date = `%>%`(...)`.
#> Caused by warning in `gsub()`:
#> ! argument 'pattern' has length > 1 and only the first element will be used

SP_salaries
#> # A tibble: 357 × 19
#>    Group Classification Effective.Date    date   Step.1 Step.2 Step.3 Step.4
#>    <chr> <chr>          <chr>             <date>  <dbl>  <dbl>  <dbl>  <dbl>
#>  1 SP    1              $) October 1, 20… NA      68896  71795  74697  77593
#>  2 SP    1              X) Wage Adjustme… NA      69447  72369  75295  78214
#>  3 SP    1              A) October 1, 20… NA      70836  73816  76801  79778
#>  4 SP    1              Y) Wage Adjustme… NA      70978  73964  76955  79938
#>  5 SP    1              B) October 1, 20… NA      72398  75443  78494  81537
#>  6 SP    1              C) October 1, 20… NA      73484  76575  79671  82760
#>  7 SP    1              D) October 1, 20… NA      74586  77724  80866  84001
#>  8 SP    2              $) October 1, 20… NA         NA     NA     NA     NA
#>  9 SP    2              X) Wage Adjustme… NA         NA     NA     NA     NA
#> 10 SP    2              A) October 1, 20… NA         NA     NA     NA     NA
#> # ℹ 347 more rows
#> # ℹ 11 more variables: Step.5 <dbl>, Step.6 <dbl>, Step.7 <dbl>, Step.8 <dbl>,
#> #   Step.9 <dbl>, Step.10 <dbl>, Step.11 <dbl>, Step.12 <dbl>, Step.13 <dbl>,
#> #   Step.14 <dbl>, Range.Step.1 <chr>
```
