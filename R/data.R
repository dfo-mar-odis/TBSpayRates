#' @title TBS groups and classifications
#' @description The groups and classifications that this package can currently extract from the TBS website.
#' @format A data frame with 284 rows and 2 variables:
#' \describe{
#'   \item{\code{Group}}{character TBS groups that can be used in `get_salaries()`}
#'   \item{\code{Classification}}{character The classifications found in each group}
#'}
#' @details R script to download/create the data is in [data-raw/groups.R](https://github.com/dfo-mar-odis/TBSpayRates/blob/main/data-raw/groups.R)
"groups"
