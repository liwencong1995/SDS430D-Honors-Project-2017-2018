#install.packages("devtools")
devtools::install_github("beanumber/nyctaxi")
library(nyctaxi)

#Creat the connection
library(RMySQL)
#mysql connection
db <- src_mysql("nyctaxi", user = "WencongLi", host = "localhost", password = "P320718")
taxi <- etl("nyctaxi", dir = "~/Desktop/nyctaxi/", db)

#Download the data I need for my study
taxi %>%
  etl_extract(years = 2015, months = 1:12, types = c("green","yellow")) %>% 
  etl_transform(years = 2015, months = 1:12, types = c("green","yellow")) %>% 
  etl_load(years = 2015, months = 1:12, types = c("green","yellow"))

taxi %>%
  etl_extract(years = 2014, months = 1:12, types = c("yellow", "green")) %>% 
  etl_transform(years = 2014, months = 1:12, types = c("yellow", "green")) %>% 
  etl_load(years = 2014, months = 1:12, types = c("yellow","green"))

taxi %>%
  etl_extract(years = 2011, months = 1:12, types = c("yellow")) %>% 
  etl_transform(years = 2011, months = 1:12, types = c("yellow")) %>% 
  etl_load(years = 2011, months = 1:12, types = c("yellow"))




library(dplyr)
library(leaflet)
library(lubridate)