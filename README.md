# NCEI_Lebanon_download

Weekly Download of NOAA NCEI data at Lebanon Airport using the rnoaa package

## Purpose

This repository contains Local Climatological Data (LCD) form NOAA's NCEI data for Lebanon Airport, near Lake Sunapee. It is meant for use by those working at/near the lake for model creation/automation and for *in situ* data truthing. 

Repository maintained by B. Steele (steeleb@caryinstitute.org).

## File Descriptions

download_compile.R: This script uses to rnoaa package to access the lcd data for Lebanon Airport, collates with existing data, and saves the file. Note that this uses the CRAN version and a very annoying workaround to access the cache file when you run lcd(). Hopefully a release in the near future will solve this bug. It has been reported to ropensci. If you aren't running on virtual machine (which requires PAT's which are currently being really funky, too), you can just grab the latest verstion at github (code commented in this file).

NCEI_Lebanon_hourly_*DATE*_*DATE*.csv: This file contains all data obtained using ther rnoaa package, via the GitHub action. The dates represent the first and last dates included in the file.

### historical folder

This folder contains historical LCD data from Lebanon Airport. 

The provided script was used to collate the data from manual downloads from the NCEI LCD website (https://www.ncdc.noaa.gov/cdo-web/datatools/lcd). Collation and use of the provided script was performed on B Steele's local machine. Contact for upstream files, if needed.

## Column Definitions and Units

See the LCD_Documentation.pdf for a complete list of definitions and units for the action dataset and the historical file.

Presumably due to differences in elevation, the barometric pressure reported at Lebanon Airport is about 1.7kpa higher than what has been measured at Sunapee via the reference transducer (recording temperature and pressure) under the LSPA porch.

Many variables reported here (like percipitation), can occur as localized events, and given that Lebanon Airport is ~34km away, local records will not be identical to the NCEI records.

All data should be considered preliminary and no QAQC has been completed on them. 

## Data Citation

NOAA. Local Climatological Data. NCEI, https://www.ncdc.noaa.gov/cdo-web/datatools/lcd.

Scott Chamberlain (2022). rnoaa: 'NOAA' Weather Data from R. https://docs.ropensci.org/rnoaa/ (docs), https://github.com/ropensci/rnoaa (devel).

