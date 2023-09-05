
#' get_salaries
#'
#' @param groups character vector with the groups listed here: https://www.tbs-sct.canada.ca/pubs_pol/hrpubs/coll_agre/rates-taux-eng.asp Note that this function only supports select groups. Use "all" (default) to download all supported groups
#'
#' @return dataframe with public service pay rates
#' @export
#'
#' @examples
#' # getting salaries for the SP (Applied Science and Patent Examination) group
#' SP_salaries <- get_salaries("SP")
#'
#' \dontrun{
#' # getting all supported salaries
#' all_salaries <- get_salaries()}
get_salaries <- function(groups="all"){

  base_url <- "https://www.tbs-sct.canada.ca/agreements-conventions/view-visualiser-eng.aspx?id="

  urls <- list(AI=paste0(base_url,"2"),
               AO=paste0(base_url,"5"),
               AV=paste0(base_url,"6"),
               CS=paste0(base_url,"1"),
               CX=paste0(base_url,"7"),
               # EB=paste0(base_url,"8"), #formatting is too wild!
               EC=paste0(base_url,"4"),
               EL=paste0(base_url,"9"),
               FB=paste0(base_url,"10"),
               FI=paste0(base_url,"11"),
               FS=paste0(base_url,"12"),
               LP=paste0(base_url,"13"),
               NR=paste0(base_url,"16"),
               PA=paste0(base_url,"15"),
               PR=paste0(base_url,"14"),
               RE=paste0(base_url,"18"),
               RO=paste0(base_url,"17"),
               # SH=paste0(base_url,"19"), # subgroups, TBD later
               SO=paste0(base_url,"20"),
               SP=paste0(base_url,"3"),
               # `SR-C`=paste0(base_url,"21"),
               # # `SR-E`=paste0(base_url,"22"), #formatting is too wild!
               # # `SR-W`=paste0(base_url,"23"), #formatting is too wild!
               # SV=paste0(base_url,"24"), # subgroups, TBD later
               TC=paste0(base_url,"25"),
               TR=paste0(base_url,"26"),
               UT=paste0(base_url,"27"))

  # get web pages for selected groups
  if(all(groups=="all")){
    pages <- lapply(urls,rvest::read_html)
  } else {
    if(all(groups %in% names(urls))){
      pages <- lapply(urls[groups],rvest::read_html)
    } else {
      stop(paste(groups[!(groups %in% names(urls))],
                 "is not a valid group. Restrict choices to:",
                 paste(names(urls),
                       collapse = ", ")))
    }

  }

  # extract salary tables
  tables <- lapply(pages,rvest::html_elements,"table")

  correcttables <- lapply(tables, function(x) x[grepl("Effective Date",rvest::html_text2(x),ignore.case = TRUE)&
                                                  grepl("annual",rvest::html_text2(x),ignore.case = TRUE)])

  salarytables <- lapply(correcttables,
                         rvest::html_table)

  # Clean up classifications
  classifications <- correcttables %>%
    lapply(function(y) y %>%
             lapply(function(x) (x %>% rvest::html_children())[1] %>%
                      gsub('<caption class="text-left">\r\n',"",.) %>%
                      gsub('<caption class=\"text-left\">\r\n            ',"",.)  %>%
                      gsub("<.*?>","",.)  %>%
                      iconv(., "UTF-8", "ASCII", "Unicode") %>%
                      gsub('<U+00A0>',"",.) %>%
                      gsub('<.*?>',"",.) %>%
                      gsub('table .',"",.) %>%
                      gsub('note .',"",.) %>%
                      gsub(' . Annual.*',"",.,ignore.case=TRUE) %>%
                      gsub(' annual.*',"",.) %>%
                      gsub(' Step.*',"",.) %>%
                      gsub(':.*',"",.) %>%
                      gsub('\\\r.*',"",.) %>%
                      gsub('<strong>',"",.) %>%
                      gsub('</strong>',"",.) %>%
                      trimws("left")) %>%
                      gsub('-$',"",.) %>%
                      gsub('[-]([1-9])', "-0\\1",.) %>%
                      trimws("both")) %>%
             unlist()
    )

  for(i in 1:length(classifications)){
    names(salarytables[[i]]) <- classifications[[i]]
  }

  # clean up and bind all tables
  megadf <- lapply(salarytables %>%
                     lapply(function(y) lapply(y, function(x) x %>%
                                                 dplyr::mutate(dplyr::across(!dplyr::where(is.character),as.character)) %>%
                                                 dplyr::rename(dplyr::any_of(
                                                   c(`Effective Date`="Effective date")
                                                 )) %>%
                                                 dplyr::rename_with(make.names)
                     )),
                   dplyr::bind_rows,.id = "Classification") %>%
    dplyr::bind_rows(.id="Group") %>%
    tidyr::pivot_longer(!c(.data$Group,.data$Classification,.data$Effective.Date),
                        names_to = "step",
                        values_to = "salary",
                        values_drop_na = TRUE) %>%
    dplyr::filter(!grepl("table",.data$salary,ignore.case=TRUE)) %>%
    dplyr::filter(!grepl("pay",.data$salary,ignore.case=TRUE)) %>%
    dplyr::mutate(step=dplyr::if_else(grepl("Range\\.",.data$step,),"Range.Step.1",.data$step),
                  Effective.Date=gsub("table .*","",.data$Effective.Date)) %>%
    tidyr::pivot_wider(names_from = .data$step,
                       values_from = .data$salary) %>%
    dplyr::relocate(dplyr::starts_with("Range"),.after=dplyr::starts_with("Step")) %>%
    dplyr::mutate(date=.data$Effective.Date %>%
                    gsub("Wage Adjustment","",.,ignore.case=TRUE) %>%
                    gsub("Market Adjustment","",.,ignore.case=TRUE) %>%
                    gsub("Pay Line Adjustment","",.,ignore.case=TRUE) %>%
                    gsub("Effective","",.,ignore.case=TRUE) %>%
                    gsub(".\\)","",.) %>%
                    gsub("Restructure \\(within 180 days after signin","",.,ignore.case=TRUE) %>%
                    gsub("[[:punct:]]","",.) %>%
                    gsub("[^ a-zA-Z0-9]"," ",.) %>%
                    trimws() %>%
                    as.Date("%B %d %Y")
    ) %>%
    dplyr::relocate(date,.after="Effective.Date") %>%
    dplyr::mutate(dplyr::across(dplyr::starts_with("step"),function(x) as.numeric(gsub(",","",x)))) #%>%
    #tidyr::separate_wider_delim(Range)

}
