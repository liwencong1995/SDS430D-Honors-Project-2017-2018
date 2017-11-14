#Creat the connection
library(RMySQL)
#mysql connection
db <- src_mysql("nyctaxi", user = "WencongLi", host = "localhost", password = "P320718")
taxi <- etl("nyctaxi", dir = "/Volumes/UNTITLED/Honors/nyctaxi", db)

taxi <- etl("nyctaxi", dir = "~/Desktop/nyctaxi")

taxi %>%
  etl_extract(years = 2015, months = 1:12, types = c("yellow"), transportation = "uber") %>% 
  etl_transform(years = 2015, months = 1:12, types = c("yellow"), transportation = "uber") %>% 
  etl_load(years = 2015, months = 1:12, types = c("yellow"), transportation = "uber")

taxi %>% 
  etl_extract(years = 2014, months = 1:12, types = c("green"), transportation = "uber") %>% 
  etl_transform(years = 2014, months = 1:12, types = c("green"), transportation = "uber") %>% 
  etl_load(years = 2014, months = 1:12, types = c("green"), transportation = "uber") 

