
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
#> Warning: There were 5 warnings in `dplyr::mutate()`.
#> The first warning was:
#> i In argument: `dplyr::across(...)`.
#> Caused by warning:
#> ! NAs introduced by coercion
#> i Run `dplyr::last_dplyr_warnings()` to see the 4 remaining warnings.
```

``` r
head(salaries)
```

| Group | Classification | Effective.Date                            | date       | Step.1 | Step.2 | Step.3 | Step.4 | Step.5 | Step.6 | Step.7 | Step.8 | Step.9 | Step.10 | Step.11 | Step.12 | Step.13 | Step.14 | Step.15 | Step.16 | Range.Step.1 |
|:------|:---------------|:------------------------------------------|:-----------|-------:|-------:|-------:|-------:|-------:|-------:|-------:|-------:|-------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|:-------------|
| SP    | AC-01          | \$) October 1, 2021                       | 2021-10-01 |  74586 |  77724 |  80866 |  84001 |  87137 |  90880 |  94605 |  98128 | 101501 |  104890 |  108824 |  112907 |  116988 |  121751 |      NA |      NA | NA           |
| SP    | AC-01          | A\) October 1, 2022                       | 2022-10-01 |  77197 |  80444 |  83696 |  86941 |  90187 |  94061 |  97916 | 101562 | 105054 |  108561 |  112633 |  116859 |  121083 |  126012 |      NA |      NA | NA           |
| SP    | AC-01          | W\) October 1, 2022 – Wage adjustment     | 2022-10-01 |  78162 |  81450 |  84742 |  88028 |  91314 |  95237 |  99140 | 102832 | 106367 |  109918 |  114041 |  118320 |  122597 |  127587 |      NA |      NA | NA           |
| SP    | AC-01          | B\) October 1, 2023                       | 2023-10-01 |  80507 |  83894 |  87284 |  90669 |  94053 |  98094 | 102114 | 105917 | 109558 |  113216 |  117462 |  121870 |  126275 |  131415 |      NA |      NA | NA           |
| SP    | AC-01          | X\) October 1, 2023 – Pay line adjustment | 2023-10-01 |  80910 |  84313 |  87720 |  91122 |  94523 |  98584 | 102625 | 106447 | 110106 |  113782 |  118049 |  122479 |  126906 |  132072 |      NA |      NA | NA           |
| SP    | AC-01          | Y\) 180 days of signing – restructure     | NA         |  84313 |  87720 |  91122 |  94523 |  98584 | 102625 | 106447 | 110106 | 113782 |  118049 |  122479 |  126906 |  132072 |  137144 |  142410 |  147878 | NA           |

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
