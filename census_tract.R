# finding census block codes and comparing fips codes

# WHAT THIS PROGRAM DOES:
# 1. reads in a df of school locations in California
# 2. subsets to LAUSD
# 3. uses the fcc API to retrieve the census tract codes for all the schools
# 4. turns that API response into a dataframe
# 5. writes that to a csv.

library(dplyr)
library(lubridate)
library(jsonlite)
library(tidyr)
library(readxl)
library(purrr)

schools <- read_excel("Documents/schools/pubschls.xlsx", skip = 5) %>%
  select(NCESDist, CDSCode, School, Latitude, Longitude) %>%
  filter(NCESDist == "0622710", 
         Latitude != "No Data") 

#apply FCC Census Block API from: https://www.fcc.gov/general/census-block-conversions-api
# https://geo.fcc.gov/api/census/block/find?latitude=38.26&longitude=-77.51&format=json
# set up empty df for the response


# create list of urls
url <- "https://geo.fcc.gov/api/census/block/find?"

request <- 
  paste0(
    url,
    "&latitude=",
    test$Latitude,
    "&longitude=",
    test$Longitude,
    "&format=json"
  )
  
# run the request
results <- request %>% lapply(., fromJSON, flatten = TRUE) 
# turn the returned lists into dfs
tracts <- lapply(results, as.data.frame.list, stringsAsFactors = FALSE)
# turn the list of dfs into one big old df
## (there's gotta be a better way to do this)
lausd_census_tracts <- bind_rows(tracts)
