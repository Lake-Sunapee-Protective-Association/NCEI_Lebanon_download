## script to collate NCDC Lebanon data ----
library(tidyverse)


datadir = 'C:/Users/steeleb/Dropbox/Lake Sunapee/weather/NCDC/Lebanon NH/'
ncdc_9399 <- read.csv(file.path(datadir, 'NCDC_lebanon_1993-1999.csv')) 
ncdc_0009 <- read.csv(file.path(datadir, 'NCDC_lebanon_2000-2009.csv'))
ncdc_1019 <- read.csv(file.path(datadir, 'NCDC_lebanon_2010-2019.csv'))
ncdc_2021 <- read.csv(file.path(datadir, 'NCDC_lebanon_2020-2021.csv'))

#get a list of columns to char -- some cols have chars in them.
list <- colnames(ncdc_0009)[3:124]

#mutate all cols to char
ncdc_9399 <- ncdc_9399 %>% 
  mutate_at(vars(list),
            ~ as.character(.))
ncdc_0009 <- ncdc_0009 %>% 
  mutate_at(vars(list),
            ~ as.character(.))
ncdc_1019 <- ncdc_1019 %>% 
  mutate_at(vars(list),
            ~ as.character(.))
ncdc_2021 <- ncdc_2021 %>% 
  mutate_at(vars(list),
            ~ as.character(.))

#join together
ncdc_9321 <- full_join(ncdc_9399, ncdc_0009) %>% 
  full_join(., ncdc_1019) %>% 
  full_join(., ncdc_2021)


#pull desired variables for hourly dataset
colnames(ncdc_9321)
ncdc_9321_hourly <- ncdc_9321 %>% 
  select(STATION, DATE, REPORT_TYPE, SOURCE, 43:58) %>%
  filter(HourlyAltimeterSetting != '') %>% 
  mutate(datetime = as.POSIXct(DATE, format = '%Y-%m-%dT%H:%M:%S', tz = 'UTC')) %>% 
  select(STATION, datetime, HourlyAltimeterSetting:HourlyWindSpeed) %>% 
  select(-HourlyPressureChange, HourlyPressureTendency, -HourlySeaLevelPressure, -HourlySkyConditions) #drop incomplete or blank cols


write.csv(ncdc_9321_hourly, file.path(datadir, 'NCDC_lebanon_hourly_1993-2021.csv'))

#pull desired vars for daioly dataset
ncdc_9321_daily <- ncdc_9321 %>% 
  select(STATION, DATE, REPORT_TYPE, SOURCE, 21:40)  %>% 
  mutate(datetime = as.POSIXct(DATE, format = '%Y-%m-%dT%H:%M:%S', tz = 'UTC'),
         date = as.Date(datetime)) %>% 
  filter(grepl('SOD', REPORT_TYPE) & SOURCE == '6')  %>% 
  select(STATION, date, DailyAverageDewPointTemperature:DailyWeather) %>% 
  select(-DailyAverageDewPointTemperature, -DailyAverageRelativeHumidity, -DailyAverageSeaLevelPressure, -DailyAverageWetBulbTemperature, -DailyDepartureFromNormalAverageTemperature, 
         -DailySnowDepth, -DailySnowfall)
write.csv(ncdc_9321_daily, file.path(datadir, 'NCDC_lebanon_daily_1998-2021.csv'))
