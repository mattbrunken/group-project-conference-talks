# read in data
# get files and filepath for conference data
files <- list.files('C:\\Users\\Matt\\Documents\\School\\Stat426\\gen-conf\\gen-conf\\data')
filepath <- 'C:\\Users\\Matt\\Documents\\School\\Stat426\\gen-conf\\gen-conf\\data\\'

# read in all files and rbind them together
conf_all <- do.call(rbind, lapply(paste0(filepath, files), read.csv))

# talk_text is factor, make it a character
conf_all$talk_text <- as.character(conf_all$talk_text)

# create word count column
for(i in 1:nrow(conf_all)){
  conf_all$word_count[i] <- ngram::wordcount(conf_all[i, 'talk_text'], sep = ' ', count.function = sum)
}

# make a .csv of this 
write.csv(conf_all, file = 'C:\\Users\\Matt\\Documents\\School\\Stat426\\gen-conf\\gen-conf\\data\\all_conference.csv')
write.csv(conf_all, file = 'C:\\Users\\Matt\\Documents\\School\\Stat426\\group_project\\all_conference.csv')

