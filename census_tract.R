# finding census block codes and comparing fips codes

# WHAT THIS PROGRAM DOES:
# 1. reads in 2010-16 storm events
# 2. builds a loop using the fcc api to return census
#    block codes for all events.
# 3. pauses the API request every 1000 calls
# 4. performs checks on the requests to make sure they're not too far off.
# 5. saves those checks (because they might be useful later)
# 6. cbinds the relevant results to the dataset and writes to csv.

library(dplyr)
library(lubridate)
library(jsonlite)
library(tidyr)
library(readxl)
library(purrr)

schools <- read_excel("Documents/schools/pubschls.xlsx", skip = 5)
test <- schools %>%
  select(NCESDist, CDSCode, School, Latitude, Longitude) %>%
  filter(NCESDist == "0622710", 
         Latitude != "No Data") %>%
  head(12)


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
frank <- lapply(results, as.data.frame.list, stringsAsFactors = FALSE)
# turn the list of dfs into one big old df
## (there's gotta be a better way to do this)
caitlin <- bind_rows(frank)
