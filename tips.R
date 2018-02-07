#tips

high_tip <- yellow_2016.08 %>%
  filter(tip_amount > fare_amount )

tip_region <- yellow_2016.08 %>%
  filter(fare_amount > 0) %>%
  filter(tip_amount < fare_amount) %>%
  mutate(tip_perct = tip_amount/fare_amount) %>%
  group_by(PULocationID, DOLocationID) %>%
  summarise(avg_tip = mean(tip_perct), trips = n(),
            avg_dis = mean(trip_distance)) %>%
  filter(trips > 10) %>%
  arrange(desc(DOLocationID), desc(avg_tip)) %>%
  rename(LocationID = PULocationID) 

tip_region <- left_join(tip_region, taxi_zone_lookup, by = "LocationID")

tip_high_region <- tip_region %>%
  group_by(DOLocationID) %>%
  top_n(10, avg_tip)

tip_high_region_sum <- tip_high_region %>%
  group_by(Borough, Zone) %>%
  summarise(freq = n()) %>%
  arrange(desc(freq))

write.csv(tip_high_region_sum, "~/Desktop/Honors Thesis/mysql/tip_high_region.csv")
