#install.packages("devtools")
devtools::install_github("beanumber/nyctaxi")
library(nyctaxi)

#Creat the connection
library(RMySQL)
#mysql connection
db <- src_mysql("nyctaxi", user = "WencongLi", host = "localhost", password = "P320718")
taxi <- etl("nyctaxi", dir = "/Volumes/UNTITLED/Honors/nyctaxi", db)

taxi <- etl("nyctaxi", dir = "~/Desktop/nyctaxi", db)


#Download the data I need for my study
#yellow taxi 2015
taxi %>%
  etl_extract(years = 2015, months = 1, types = c("yellow")) %>% 
  etl_transform(years = 2015, months = 1, types = c("yellow")) %>%
  etl_load(years = 2015, months = 1, types = c("yellow"))

taxi%>%
  etl_init() %>% 
  etl_load(years = 2015, months = 1:12, types = c("yellow"))
  

taxi %>%
  tbl("yellow")

# green taxi 2016 testing etl_load
taxi %>%
  etl_extract(years = 2016, months = 1, types = c("green")) %>% 
  etl_transform(years = 2016, months = 1, types = c("green")) %>% 
  etl_load(years = 2016, months = 1, types = c("green"))

#testing sqlite
taxi %>%
  tbl("green")

#green check column number
taxi %>%
  etl_extract(years = 2013, months = 12, types = c("green")) %>% 
  etl_transform(years = 2013, months = 12, types = c("green")) %>% 
  etl_load(years = 2013, months = 12, types = c("green"))


#test the transform function
taxi %>%
  etl_extract(years = 2013:2016, months = 12, types = c("green"))

taxi %>%
  etl_transform(years = 2013:2016, months = 12, types = c("green"))

taxi %>%
  etl_load(years = 2013:2016, months = 12, types = c("green"))

library(dplyr)
library(leaflet)
library(lubridate)