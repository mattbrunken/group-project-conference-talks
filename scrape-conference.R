# Packages ----
library(tidyverse)
library(tidytext)

# Utils ----
source(here::here('R', "utils.R"))

# Build conference URLs
root_url <- "https://www.lds.org/general-conference/"
months <- c("04", "10")
n_years <- 20
current_year <- lubridate::year(Sys.Date())
years <- (current_year - n_years):current_year
conf_urls <- glue::glue("{root_url}{rep(years, each = 2)}/{rep(months, length(years))}?lang=eng")

# Validate each URL
valid_urls <- map_lgl(conf_urls, RCurl::url.exists)
conf_urls <- conf_urls[valid_urls]

# Scrape and save
walk(conf_urls, function(conf_url){
  message(glue::glue("Scraping: {conf_url}"))
  dates <- glue::glue_collapse(stringr::str_extract_all(conf_url, "[0-9]{2,}", simplify = TRUE), sep = "-")
  file_name <- here::here(glue::glue("data","{dates}-conference.csv"))
  if (!file.exists(file_name)) {
    message(glue::glue("Saving data to {file_name}"))
    write_csv(scrape_conference(conf_url), file_name)
  } else {
    message(glue::glue("{file_name} already exists."))
  }
})

# Combine all saved data and create one complete dataset
all_conference_data <- fs::dir_ls(here::here("data")) %>% 
  str_subset("[0-9]{4}-[0-9]{2}-conference.csv") %>% 
  map_df(read_csv) %>% 
  filter(!is.na(talk_text))

write_csv(all_conference_data, here::here("data", "all-conferences.csv"))

# Tidy all conference data
tidy_conference <- all_conference_data %>% 
  unnest_tokens(word, talk_text)

write_csv(tidy_conference, here::here("data", "tidy-conference.csv"))

word_counts <- tidy_conference %>% 
  select(-talk_url) %>% 
  group_by(year, month, session, talk_title, speaker) %>% 
  count(name = "words")

write_csv(word_counts, here::here("data", "conference-word-counts.csv"))
