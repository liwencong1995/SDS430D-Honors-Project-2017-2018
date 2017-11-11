#install.packages("devtools")
devtools::install_github("beanumber/nyctaxi")
library(nyctaxi)

#Creat the connection
library(RMySQL)
#mysql connection
db <- src_mysql("nyctaxi", user = "WencongLi", host = "localhost", password = "P320718")
taxi <- etl("nyctaxi", dir = "/Volumes/UNTITLED/Honors/nyctaxi", db)

#Download the data I need for my study
#yellow taxi 2015
taxi %>%
  etl_extract(years = 2015, months = 1:12, types = c("yellow")) %>% 
  etl_transform(years = 2015, months = 1:12, types = c("yellow")) 

taxi%>%
  etl_init()%>% 
  etl_load(years = 2015, months = 1:12, types = c("yellow"))
  

taxi %>%
  tbl("yellow")

# green taxi 2015
taxi %>%
  etl_extract(years = 2015, months = 1:12, types = c("green")) %>% 
  etl_transform(years = 2015, months = 1:12, types = c("green")) %>% 
  etl_load(years = 2015, months = 1:12, types = c("green"))

taxi %>%
  tbl("green")


  
taxi %>%
  etl_extract(years = 2011, months = 1:12, types = c("yellow")) %>% 
  etl_transform(years = 2011, months = 1:12, types = c("yellow")) %>% 
  etl_load(years = 2011, months = 1:12, types = c("yellow"))




library(dplyr)
library(leaflet)
library(lubridate)