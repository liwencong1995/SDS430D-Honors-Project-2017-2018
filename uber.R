install.packages("devtools")
devtools::install_github("beanumber/nyctaxi")
library(nyctaxi)
taxi <- etl("nyctaxi", dir = "~/Desktop/nyctaxi/")
taxi %>%
  etl_extract(years = 2014:2015, months = 1:12, transportation = "uber") 
