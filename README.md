
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TBSpayRates

<!-- badges: start -->

[![R-CMD-check](https://github.com/dfo-mar-odis/TBSpayRates/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dfo-mar-odis/TBSpayRates/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of TBSpayRates is to extract rates of pay for public servants
from the [Treasury Board of
Canada](https://www.tbs-sct.canada.ca/pubs_pol/hrpubs/coll_agre/rates-taux-eng.asp)
Secretariat and tools for project planning/salary forecasting.

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

head(SP_salaries)
#> # A tibble: 6 × 19
#>   Group Classification Effective.Date     date       Step.1 Step.2 Step.3 Step.4
#>   <chr> <chr>          <chr>              <date>      <dbl>  <dbl>  <dbl>  <dbl>
#> 1 SP    AC-1           $) October 1, 2017 2017-10-01  68896  71795  74697  77593
#> 2 SP    AC-1           X) Wage Adjustmen… 2018-10-01  69447  72369  75295  78214
#> 3 SP    AC-1           A) October 1, 2018 2018-10-01  70836  73816  76801  79778
#> 4 SP    AC-1           Y) Wage Adjustmen… 2019-10-01  70978  73964  76955  79938
#> 5 SP    AC-1           B) October 1, 2019 2019-10-01  72398  75443  78494  81537
#> 6 SP    AC-1           C) October 1, 2020 2020-10-01  73484  76575  79671  82760
#> # ℹ 11 more variables: Step.5 <dbl>, Step.6 <dbl>, Step.7 <dbl>, Step.8 <dbl>,
#> #   Step.9 <dbl>, Step.10 <dbl>, Step.11 <dbl>, Step.12 <dbl>, Step.13 <dbl>,
#> #   Step.14 <dbl>, Range.Step.1 <chr>
```

## Contributing

Please visit this package’s [Github
repo](https://github.com/dfo-mar-odis/TBSpayRates) to contribute or
submit issues.

## Code of Conduct

Please note that the TBSpayRates project is released with a [Contributor
Code of
Conduct](https://dfo-mar-odis.github.io/TBSpayRates/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
