#' get_salaries
#'
#' This function gets the publicly available DFO salary information from
#' https://www.tbs-sct.canada.ca/pubs_pol/hrpubs/coll_agre/rates-taux-eng.asp.
#'
#' Disclaimer: If you're obtaining salary information for group="TC", subgroup=TI
#' this function obtains the first classification tables and ignores ones that are
#' specific to Aviation, Marine, and Railway Safety.
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
               #PR=paste0(base_url,"14"), hourly rate. Can do if needed.
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
    response <- lapply(urls, httr::GET)
  } else {
    if(all(groups %in% names(urls))){
      pages <- lapply(urls[groups],rvest::read_html)
      response <- lapply(urls[groups], httr::GET)
    } else {
      stop(paste(groups[!(groups %in% names(urls))],
                 "is not a valid group. Restrict choices to:",
                 paste(names(urls),
                       collapse = ", ")))
    }

  }


  # TEST if there are any "Toronto" tables (e.g. group = "PL")
  # Test if any "Engineering and Scientific Support Group" group = TC EG-2
  # For subgroup = TI, there are classifications Aviation, Railway Safety, and Marine. We will only be focusing on Marine for our purposes
  content <- lapply(response, function(x) httr::content(x, as="text"))
  lines <- lapply(content, function(x) strsplit(x, "\n")[[1]])
  tableLines <- lapply(lines, function(x) grep("<table", x))

  tables <- lapply(pages,rvest::html_elements,"table")

  toronto <- FALSE
  supportGroup <- FALSE
  technicalInspection <- FALSE
  CSHour <- FALSE

  for (l in seq_along(lines)) {
    line <- lines[[l]]
    if (any(line == "            <h4>II: Toronto (BUD 21401)</h4>\r")) {
      toronto <- TRUE
      # group = PL
      bad <- which(line == "            <h4>II: Toronto (BUD 21401)</h4>\r")
      tableLines[[l]] <- tableLines[[l]][-which(tableLines[[l]] > bad)]
    }

    if (any(line == "                <h3 id=\"MainContent_CAContentControl_CAContentRepeater_ArticleRepeater_7_H3Element_2\">EG: Engineering and Scientific Support Group annual rates of pay for salary protected employees (in\r")){ # TC
      supportGroup <- TRUE
      bad <- which(line == "                <h3 id=\"MainContent_CAContentControl_CAContentRepeater_ArticleRepeater_7_H3Element_2\">EG: Engineering and Scientific Support Group annual rates of pay for salary protected employees (in\r")
      tableLines[[l]] <- tableLines[[l]][-(which(tableLines[[l]] == tableLines[[l]][which(tableLines[[l]] > bad)[1]]))]
      tables[[l]] <- tables[[l]][-(which(tableLines[[l]] == tableLines[[l]][which(tableLines[[l]] > bad)[1]]))]
    }

    if (any(line == "                <h3 id=\"MainContent_CAContentControl_CAContentRepeater_ArticleRepeater_8_H3Element_0\">TI: Technical Inspection Group annual rates of pay: aviation, marine, railway safety (in dollars)</h3>\r")) { # TC
      technicalInspection <- TRUE
      bad <- which(line == "                <h3 id=\"MainContent_CAContentControl_CAContentRepeater_ArticleRepeater_8_H3Element_0\">TI: Technical Inspection Group annual rates of pay: aviation, marine, railway safety (in dollars)</h3>\r")
      tableLines[[l]] <- tableLines[[l]][-which(tableLines[[l]] > bad)]
      warning("You are obtaining TI salary information from group='TC'. Please see get_salaries() documentation for disclaimer")
    }

    if (any(line == "                <h3 id=\"MainContent_CAContentControl_CAContentRepeater_ArticleRepeater_6_H3Element_0\">CS: Computer Systems Group weekly, daily and hourly rates of pay</h3>\r")) {
      CSHour <- TRUE
      bad <- which(line == "                <h3 id=\"MainContent_CAContentControl_CAContentRepeater_ArticleRepeater_6_H3Element_0\">CS: Computer Systems Group weekly, daily and hourly rates of pay</h3>\r")
      tableLines[[l]] <- tableLines[[l]][-which(tableLines[[l]] > bad)]
    }

  }

  # extract salary tables
  if (toronto | technicalInspection | CSHour) {
    for (i in seq_along(tables)) {
      tables[[i]] <- tables[[i]][1:length(tableLines[[i]])]
    }
  }

  correcttables <- NULL
  for (g in seq_along(groups)) {
    tab <- tables[[g]]
    k <- which(grepl("Effective Date", html_text2(tab), ignore.case=TRUE))
    k1 <- which(grepl("step", html_text2(tab), ignore.case=TRUE))
    k2 <- which(grepl("range", html_text2(tab), ignore.case=TRUE))
    k3 <- unique(c(k1,k2))
    keep <- sort(unique(intersect(k,k3)))
    correcttables[[g]] <- tab[keep]
  }
  names(correcttables) <- groups




  if (length(correcttables[[1]]) == 0) {
    # This means no tables with "Effective Date" AND "annual" are found (e.g. group="CX")
    correcttables <- lapply(tables, function(x) x[grepl("Effective Date",rvest::html_text2(x),ignore.case = TRUE)])
  }

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
                      gsub('<U+00A0>'," ",., ignore.case = TRUE) %>%
                      gsub('<.*?>',"-",., ignore.case=TRUE) %>%
                      gsub('table .',"",., ignore.case=TRUE) %>%
                      gsub('note .',"",., ignore.case=TRUE) %>%
                      gsub(' . Annual.*',"",.,ignore.case=TRUE) %>%
                      gsub(' annual.*',"",.,ignore.case=TRUE) %>%
                      gsub(' Step.*',"",., ignore.case=TRUE) %>%
                      sub("\\(Steps.*", "", .) %>%
                      gsub(':.*',"",.) %>%
                      gsub('\\\r.*',"",.) %>%
                      gsub('-$',"",.) %>%
                      gsub('[-]([1-9])', "-0\\1",.) %>%
                      trimws("both")) %>%
             unlist()
    )

  for(i in 1:length(classifications)){
    names(salarytables[[i]]) <- classifications[[i]]
  }



  # Check for "Table" at the end of each data frames
  # Remove table in effective date ("A) May 10, 2018table 1 note 1" group ="LP")
  # Check for intermediate steps of $60 at beginning (group="NR" subgroup=EN-ENG)

  for (j in seq_along(groups)) {
    for (i in seq_along(salarytables[[j]])) {
    salarytables[[j]][[i]] <- dplyr::rename(salarytables[[j]][[i]], dplyr::any_of(
        c(`Effective Date`="Effective date")
      ))
    s <- salarytables[[j]][[i]]

    salarytables[[j]][[i]]$`Effective Date`[which(grepl("-", salarytables[[j]][[i]]$`Effective Date`))] <- gsub("\\s*-\\s*", "-", salarytables[[j]][[i]]$`Effective Date`[which(grepl("-", salarytables[[j]][[i]]$`Effective Date`))]) # This is for group = TC (June 22, 2023 - Pay and June 22,2023-Pay)
    if (grepl("table", s$`Effective Date`[length(s$`Effective Date`)], ignore.case = TRUE)) {
      s$`Effective Date` <- unlist(lapply(strsplit(s$`Effective Date`, "table"), function(x) x[1]))
      salarytables[[j]][[i]] <- s[1:(length(s$`Effective Date`)-1),]
    }

    #monday jaim

    if (any(grepl("intermediate steps of \\$60", s$`Effective Date`, ignore.case=TRUE))) {
      salarytables[[j]][[i]] <- salarytables[[j]][[i]][-1,]
    }
    }
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
                   dplyr::bind_rows,.id = "Classification")%>%
    dplyr::bind_rows(.id="Group") %>%
    tidyr::pivot_longer(!c(Group,Classification,Effective.Date),
                        names_to = "step",
                        values_to = "salary",
                        values_drop_na = TRUE)%>%
    dplyr::filter(!grepl("table",salary,ignore.case=TRUE)) %>%
    dplyr::filter(!grepl("pay",salary,ignore.case=TRUE)) %>%
    dplyr::mutate(step=dplyr::if_else(grepl("Range\\.",step,),"Range.Step.1",step),
                  Effective.Date=gsub("table .*","",Effective.Date)) %>%
    tidyr::pivot_wider(names_from = step,
                       values_from = salary)%>%
    dplyr::relocate(dplyr::starts_with("Range"),.after=dplyr::starts_with("Step"))%>%
    dplyr::mutate(date=Effective.Date %>%
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
    dplyr::relocate(date,.after="Effective.Date")%>%
    dplyr::mutate(dplyr::across(dplyr::starts_with("step"),function(x) as.numeric(gsub(",","",x)))) #%>%
    #tidyr::separate_wider_delim(Range)

}
