library(magrittr)
groups <- TBSpayRates::get_salaries(groups="all") %>%
  dplyr::select(Group,Classification) %>%
  unique()

usethis::use_data(groups, overwrite = TRUE, compress = "xz")

sinew::makeOxygen(groups)
