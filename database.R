library(lubridate)
library(dplyr)
db <- src_mysql("nyctaxi", user = "wli37", host = "scidb.smith.edu", password = "Calculati0n")
taxi <- etl("nyctaxi", db)

webshot::install_phantomjs()
webshot("https://www.r-project.org/", "r-viewport.png", cliprect = "viewport")


taxi_summary_2017 <- taxi %>%
  tbl("yellow") %>%
  mutate(year = year(tpep_pickup_datetime),
         month = month(tpep_pickup_datetime)) %>%
  group_by(year, month) %>%
  summarise(N = n()) %>%
  collect()
  
  