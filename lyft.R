#Creat the connection
library(RMySQL)
#mysql connection
db <- src_mysql("nyctaxi", user = "WencongLi", host = "localhost", password = "P320718")
taxi <- etl("nyctaxi", dir = "/Volumes/UNTITLED/Honors/nyctaxi", db)

taxi %>%
  etl_extract(years = 2015:2017, months = 1:12, transportation = "lyft") %>% 
  etl_transform(years = 2015:2017, months = 1:12, transportation = "lyft")

taxi %>%  
  etl_load(years = 2015:2017, months = 1:12, types = c("yellow"), transportation = "lyft")

lyft <- taxi %>% tbl("lyft") %>% collect()
