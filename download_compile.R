library(tidyverse)
# remotes::install_github("ropensci/rnoaa") #cran version gets upset with characters in numeric columns, must use dev version
library(rnoaa)

#today's date
today <- Sys.Date()

#get current year lcd data
now <-  lcd(station = '72611694765',
           year = as.numeric(format(today, '%Y')))

#get column names
header <- colnames(now)[1:7]
hourly <- colnames(now)[grepl('hourly', colnames(now))]

#subset for hourly data only
now_hourly <- now %>% 
  select(all_of(header), all_of(hourly))

#format datetime
now_hourly <- now_hourly %>% 
  mutate(datetime = as.POSIXct(date, format = '%Y-%m-%d %H:%M:%S', tz = 'Etc/GMT+5')) %>% 
  select(-date)

#point to files
action_file <- list.files(pattern = '.csv')
historical_file <- list.files(path = 'historical', pattern = '.csv')

#grab last date in historical file
if(length(action_file>0)){
  hist_file <- read.csv(action_file)
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
  action_file <- full_join(hist_file, action_add) %>% 
    arrange(datetime)
} else {
  action_file = action_add%>% 
    arrange(datetime)
}

firstdate = as.Date(min(action_file$datetime))
lastdate = as.Date(max(action_file$datetime))

write.csv(action_file, paste0('NCEI_Lebanon_hourly_', firstdate, '_', lastdate, '.csv'), row.names = F)
