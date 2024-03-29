library(tidyverse)
# remotes::install_github("ropensci/rnoaa", dependencies = T, upgrade = 'always') #cran version gets upset with numeric in character columns, 
 # must use dev version to eliminate bug, but github pat issues, soooooo see workaround below
library(rnoaa)

#today's date
today <- Sys.Date()

#get current year lcd data
try( #need this here to not fail GH action
now <-  lcd(station = '72611694765',
           year = as.numeric(format(today, '%Y')))
)

#this will only chache a download. we will now read in based on cache location. this is a bug in the rnoaa package, and until the current dev branch is published,
#we're using this stupid method.
file <- list.files(lcd_cache$cache_path_get())

now <- read.csv(file.path(lcd_cache$cache_path_get(), file))

#get column names
header <- colnames(now)[1:7]
hourly <- colnames(now)[grepl('Hourly', colnames(now))]


#subset for hourly data only
now_hourly <- now %>% 
  select(all_of(header), all_of(hourly))

#format datetime
now_hourly <- now_hourly %>% 
  mutate(datetime = as.POSIXct(DATE, format = '%Y-%m-%dT%H:%M:%S', tz = 'Etc/GMT+5')) %>% 
  select(-DATE)

#point to files
action_file <- list.files(pattern = '.csv')
historical_file <- list.files(path = 'historical', pattern = '.csv')

#grab last date in historical file
if(length(action_file>0)){
  hist_file <- read.csv(action_file) %>% 
    mutate(datetime = as.POSIXct(datetime, tz = 'Etc/GMT+5'))
  lasttime = last(hist_file$datetime)
} else {
  hist_file <- read.csv(file.path('historical', historical_file))
  lasttime = last(hist_file$datetime)
}

#filter current year to data needed to add to repo
action_add <- now_hourly %>% 
  filter(datetime > as.POSIXct(lasttime, tz = 'Etc/GMT+5'))

#concatenate with existing file, if available
if(length(action_file>0)){
  new_action_file <- full_join(hist_file, action_add) %>% 
    arrange(datetime)
  unlink(action_file) #remove previous file from file
} else {
  new_action_file = action_add%>% 
    arrange(datetime)
}

firstdate = as.Date(min(new_action_file$datetime))
lastdate = as.Date(max(new_action_file$datetime))

write.csv(new_action_file, paste0('NCEI_Lebanon_hourly_', firstdate, '_', lastdate, '.csv'), row.names = F)

