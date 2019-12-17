# group-project-conference-talks

## Introduction
This repository uses R scripts to scrape LDS General Conference talk data from the web and Python scripts to clean the data,
perform an EDA, and fit several different machine learning models for both regression and classification. The main purpose of
the regression models were to predict talk length (in words) given our data while the classifciation models were designed to
predict the general calling of a General Authority or General Officer of the Church of Jesus Christ of Latter-day Saints. 

## Content Descriptions
all_conference.csv - An uncleaned csv filled with the following variables:
  "year" - year that the talk was given
  "month" - either a 4 or a 10 representing an April or October conference
  "session" - The session of the conference whether it be Saturday/Sunday Morning/Afternoon, Priesthood, or Women's session
  "talk_title" - The name of the talk 
  "speaker" - The speaker of the talk
  "talk_url" - The URL link for the talk
  "talk_text" - All of the text in the talk
  "calling" - The speakers specific calling 
  "word_count" - Total words in the talk

conf_classification.ipynb - A notebook that fits several different classification models to predict the general calling of a
General Authority or General Officer of the Church

conf_data.csv - A cleaned csv based upon all_conference.csv which adds the following variables:
    "gen_calling" - general categories of callings based upon the "calling" variable with values of apostle, seventy, first
      presidency, prophet, nan (due to the web scraper not working for every given talk), young women, relief society,
      presiding bishopric, primary, sunday school, other, and young men.
    "speaker_gender" - the gender of the speaker
    "session_gendered" - the emphasis of the session. The General Women's session being geared towards women, the Priesthood
      session being geared towards men, and the Saturday/Sunday Morning/Afternoon sessions with a gender-neutral emphasis
      
 data_compiler.R - creates all_conference.csv from the data obtained in
 
 eda_and_regression.ipynb - currently not openable due to a updating error with git
 
 scrape-conference.R - references the utils.R web scraper and scrapes conference data and saves them as various .csv files
 
 utils.R - creates functions to scrape the data from lds.org (churchofjesuschrist.org)
