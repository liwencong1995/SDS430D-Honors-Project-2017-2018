#install.packages("devtools")
devtools::install_github("beanumber/nyctaxi")
library(nyctaxi)

#Creat the connection
library(RMySQL)
#mysql connection
db <- src_mysql("nyctaxi", user = "WencongLi", host = "localhost", password = "P320718")
taxi <- etl("nyctaxi", dir = "~/Desktop/nyctaxi")
taxi <- etl("nyctaxi", dir = "/Volumes/UNTITLED/Honors/nyctaxi", db)

#taxi <- etl("nyctaxi", dir = "~/Desktop/nyctaxi", db)
#Download the data I need for my study
#green taxi 2015
taxi %>%
  etl_extract(years = 2015, months = 1:12, types = c("green")) %>% 
  etl_transform(years = 2015, months = 1:12, types = c("green"))

taxi %>%
  etl_init()

taxi %>%
  etl_load(years = 2015, months = 1:12, types = c("green"))
  
taxi %>%
  tbl("yellow")

# green taxi: testing etl_load
taxi %>%
  etl_extract(years = 2014:2016, months = 4, types = c("green")) %>% 

taxi%>%  
  etl_transform(years = 2015, months = 1:12, types = c("green"))

taxi %>%
  etl_init()

taxi%>%
  etl_load(years = 2014:2016, months = 4, types = c("green"))

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

#---------------------------------------------------------------------------------
#install.packages("devtools")
devtools::install_github("beanumber/nyctaxi")
library(nyctaxi)
#Creat the connection
library(RMySQL)
#mysql connection
#db <- src_mysql("nyctaxi", user = "WencongLi", host = "localhost", password = "P320718")
db <- src_mysql("nyctaxi", user = "wli37", host = "scidb.smith.edu", password = "Calculati0n")
taxi <- etl("nyctaxi", dir = "/Volumes/UNTITLED/Honors/nyctaxi", db)


#Prep data for data analysis
#Yellow taxi data: Jan 2010- Dec 2016

taxi %>%
  etl_extract(years = 2010:2016, months = 1:12, types = c("yellow"))

taxi %>%
  etl_load(years = 2016, months = 1, type = "yellow")

taxi %>%
  etl_load(years = 2014, months = 7:9, type = "yellow")

taxi %>%
  etl_load(years = 2015, months = 2:6, type = "yellow")


#Green taxi data: Aug 2013 - Dec 2016
taxi %>%
  etl_extract(years = 2014:2016, months = 1:12, type = c("green")) 

taxi %>%
  etl_transform(years = 2014:2016, months = 1:12, type = c("green"))

taxi %>%
  etl_extract(years = 2013, months = 8:12, type = c("green"))

taxi %>%
  etl_transform(years = 2013, months = 8:12, type = c("green"))

taxi %>%
  etl_load(years = 2013:2016, months = 1:12, type = "green")



