scrape_conference <- function(conf_url, parallel = TRUE){
  if (parallel) {
    # Register parallel backend
    future::plan("multiprocess")
    
    # Talk function
    map_fun <- furrr::future_map_chr
  } else {
    map_fun <- purrr::map_chr
  }
  
  # Extract year and month from URL
  dates <- stringr::str_extract_all(conf_url, "[0-9]{2,}", simplify = TRUE)
  
  conf_html <- rvest::html_nodes(xml2::read_html(conf_url), ".title-block+ .lumen-layout--landing-3 .lumen-layout__item")
  
  conf <- purrr::map_df(conf_html, function(node){
    tibble::tibble(
      session = rvest::html_text(rvest::html_nodes(node, ".section__header .section__header__title")),
      talk_title = stringr::str_trim(rvest::html_text(rvest::html_nodes(node, ".lumen-tile__title"))),
      speaker = rvest::html_text(rvest::html_nodes(node, ".lumen-tile__content")),
      talk_url = rvest::html_attr(rvest::html_nodes(node, "a.lumen-tile__link"), "href")
    )
  })
  
  conf <- dplyr::mutate(conf,
                        year = as.numeric(dates[nchar(dates) == 4]),
                        month = as.numeric(dates[nchar(dates) == 2]),
                        talk_url = purrr::map_chr(talk_url, function(url){
                          p_url <- httr::parse_url(url)
                          p_url$scheme <- httr::parse_url(conf_url)$scheme
                          p_url$hostname <- httr::parse_url(conf_url)$hostname
                          httr::build_url(p_url)
                        }),
                        talk_text = map_fun(talk_url, function(url){
                          message("\t", "Scraping talk: ", url)
                          talk_nodes <- tryCatch(rvest::html_nodes(xml2::read_html(url), ".body-block p"),
                                                 error = function(e) NA)
                          if (length(talk_nodes) == 0 | rlang::is_na(talk_nodes)) {
                            as.character(NA)
                          } else {
                            glue::glue_collapse(purrr::map_chr(talk_nodes, function(node){
                              rvest::html_text(node)
                            }), sep = " ")
                          }
                        }),
                        
#################################################################################################################

calling = map_fun(talk_url, function(url){
  message("\t", "Scraping calling: ", url)
  calling_nodes <- tryCatch(rvest::html_nodes(xml2::read_html(url), "#p2"),
                         error = function(e) NA)
  if (length(calling_nodes) == 0 | rlang::is_na(calling_nodes)) {
    as.character(NA)
  } else {
    glue::glue_collapse(purrr::map_chr(calling_nodes, function(node){
      rvest::html_text(node)
    }), sep = " ")
  }
})
##################################################################################################################
  )
  
  dplyr::select(conf, year, month, dplyr::everything())
}



# this scrapes the calling (single instance)

# url <- 'https://www.churchofjesuschrist.org/study/general-conference/2019/10/11holland?lang=eng'
#  url %>%
#      read_html() %>% 
#      html_node('#author2') %>% 
#      html_text()
# url <- 'https://www.churchofjesuschrist.org/study/general-conference/2019/10/12vinson?lang=eng'
# ok <- tryCatch(rvest::html_nodes(xml2::read_html(url), '#author2'),
#          error = function(e) NA)
# 
# 
# calling = map_fun(talk_url, function(url){ # ADDED THIS PORTION
#   message("\t", "Scraping calling: ", url)
#   calling_nodes <- tryCatch(rvest::html_nodes(xml2::read_html(url), '#author2'),
#                             error = function(e) NA)
#   if (length(calling_nodes) == 0 | rlang::is_na(calling_nodes)) {
#     as.character(NA)
#   } else {
#     glue::glue_collapse(purrr::map_chr(calling_nodes, function(node){
#       rvest::html_text(node)
#     }), sep = " ")
#   } 
# })
