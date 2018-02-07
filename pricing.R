##----------------------Pricing-----------------------------------
#taking a subset of 2016 08 yellow data
yellow_1608_subset <- yellow_2016.08[sample(1:nrow(yellow_2016.08), 1000, replace = FALSE),]

data("taxi_zone_lookup")
View(taxi_zone_lookup)
## One Standard City Rate
2.5 + 0.5 * trip_distance/5 + extra + improvement_surcharge + mta_tax + tolls_amount + tip_amont

## Two JKF Airport Trips
52 + + extra + improvement_surcharge + mta_tax + tolls_amount + tip_amont

jfk <- yellow_2016.08 %>%
  filter(DOLocationID == 132)
hist(jfk$fare_amount)
summary(jfk)
#there are negative values
jfk_neg <- jfk %>% filter(fare_amount <= 0)

jfk_trip <- jfk %>%
  filter(fare_amount == 52) %>%
  mutate(est_fare = 2.5 + 0.5 * trip_distance * 5 + extra + 
           improvement_surcharge + mta_tax + tolls_amount,
         est_diff = est_fare - fare_amount)
hist(jfk_trip$est_diff, xlim = range(1,50), 
     breaks = seq(0,50,10))


ewr <- yellow_2016.08 %>%
  filter(DOLocationID == 1)
hist(ewr$fare_amount)

#LaGuadia Airport
138

## Three Neward Airport Trips
17.5 + 2.5 + 0.5 * trip_distance * 5 + extra + improvement_surcharge + mta_tax + tolls_amount + tip_amont

## Four Westchester & Nassau
# Hard to measure
# need to calculate miles travel winthin and beyond City limit
#2.5 + 0.5 * trip_distance/5 + extra + improvement_surcharge + mta_tax + tolls_amount + tip_amont

## Five Other POints Ouside the City
# mutually agreed fare amount

#http://www.nyc.gov/html/tlc/html/passenger/taxicab_rate.shtml