
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

This is a basic example which shows you how to download salaries for the
`SP` group. Alternatively, to extract all the groups supported by this
package, use `groups = "all"` in the `get_salaries()` function.

``` r
library(TBSpayRates)

SP_salaries <- get_salaries(groups = "SP")
```

``` r
head(salaries)
```

| Group | Classification | Effective.Date                        | date       | Step.1 | Step.2 | Step.3 | Step.4 | Step.5 | Step.6 | Step.7 | Step.8 | Step.9 | Step.10 | Step.11 | Step.12 | Step.13 | Step.14 | Range.Step.1 |
|:------|:---------------|:--------------------------------------|:-----------|-------:|-------:|-------:|-------:|-------:|-------:|-------:|-------:|-------:|--------:|--------:|--------:|--------:|--------:|:-------------|
| SP    | AC-1           | \$) October 1, 2017                   | 2017-10-01 |  68896 |  71795 |  74697 |  77593 |  80489 |  83947 |  87388 |  90643 |  93758 |   96890 |  100523 |  104294 |  108063 |  112464 | NA           |
| SP    | AC-1           | X\) Wage Adjustment - October 1, 2018 | 2018-10-01 |  69447 |  72369 |  75295 |  78214 |  81133 |  84619 |  88087 |  91368 |  94508 |   97665 |  101327 |  105128 |  108928 |  113364 | NA           |
| SP    | AC-1           | A\) October 1, 2018                   | 2018-10-01 |  70836 |  73816 |  76801 |  79778 |  82756 |  86311 |  89849 |  93195 |  96398 |   99618 |  103354 |  107231 |  111107 |  115631 | NA           |
| SP    | AC-1           | Y\) Wage Adjustment - October 1, 2019 | 2019-10-01 |  70978 |  73964 |  76955 |  79938 |  82922 |  86484 |  90029 |  93381 |  96591 |   99817 |  103561 |  107445 |  111329 |  115862 | NA           |
| SP    | AC-1           | B\) October 1, 2019                   | 2019-10-01 |  72398 |  75443 |  78494 |  81537 |  84580 |  88214 |  91830 |  95249 |  98523 |  101813 |  105632 |  109594 |  113556 |  118179 | NA           |
| SP    | AC-1           | C\) October 1, 2020                   | 2020-10-01 |  73484 |  76575 |  79671 |  82760 |  85849 |  89537 |  93207 |  96678 | 100001 |  103340 |  107216 |  111238 |  115259 |  119952 | NA           |

The compatible groups/classifications are store in the `groups` data
object:

``` r
data(groups)
```

``` r
head(groups)
```

| Group | Classification |
|:------|:---------------|
| AI    | AI-01          |
| AI    | AI-02          |
| AI    | AI-03          |
| AI    | AI-04          |
| AI    | AI-05          |
| AI    | AI-06          |

If desired, users can write the extracted data to a `.csv` for use
outside of R:

``` r
write.csv(SP_salaries,"SP_salaries.csv",row.names = FALSE)
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
