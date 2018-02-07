#pick-up distribution

pickup_sum <- yellow_2016.08 %>%
  group_by(PULocationID) %>%
  summarise(pickup_num = n()) %>%
  arrange(desc(pickup_num)) %>%
  rename(LocationID = PULocationID) 

pickup_region <- left_join(pickup_sum, taxi_zone_lookup, by = "LocationID")

data("taxi_zones")
View(taxi_zones)
plot(taxi_zones)

#dropoff distribution
dropoff_sum <- yellow_2016.08 %>%
  group_by(DOLocationID) %>%
  summarise(dropoff_num = n()) %>%
  arrange(desc(dropoff_num)) %>%
  rename(LocationID = DOLocationID) 

dropoff_region <- left_join(dropoff_sum, taxi_zone_lookup, by = "LocationID")
