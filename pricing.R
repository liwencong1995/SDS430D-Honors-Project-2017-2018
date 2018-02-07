##----------------------Pricing-----------------------------------
library(dplyr)
#taking a subset of 2016 08 yellow data
yellow_1608_subset <- yellow_2016.08[sample(1:nrow(yellow_2016.08), 1000, replace = FALSE),]

data("taxi_zone_lookup")
View(taxi_zone_lookup)
## One Standard City Rate
2.5 + 0.5 * trip_distance/5 + extra + improvement_surcharge + mta_tax + tolls_amount + tip_amont

## Two JKF Airport Trips-------------------------------------------
52 + + extra + improvement_surcharge + mta_tax + tolls_amount + tip_amont

jfk_trip <- yellow_2016.08 %>%
  filter(RatecodeID == 2) %>%
  filter(payment_type != 3) %>%
  filter(trip_distance > 0) %>%
  filter(fare_amount > 0) %>%
  filter(PULocationID != DOLocationID) %>%
  mutate(est_fare = 2.5 + 0.5 * trip_distance * 5 + extra + 
           improvement_surcharge + mta_tax + tolls_amount,
         est_diff = est_fare - fare_amount)

min(jfk_trip$est_diff)
#-48.675
max(jfk_trip$est_diff)
#1019.34
mean(jfk_trip$est_diff)
#-0.4708788
hist(jfk_trip$est_diff, breaks = 100)

jfk_trip_no_outlier <- jfk_trip%>%
  filter(est_diff < 100) 
mean(jfk_trip_no_outlier$est_diff)
#-0.5117455
hist(jfk_trip_no_outlier$est_diff, breaks = 30, xlimit = c(-100,100))

jfk_short_dis <- jfk_trip %>%
  filter(est_diff < 0)
#top ten zones of pickup
jfk_short_dis %>%
  filter(PULocationID != 132) %>%
  group_by(PULocationID)%>%
  summarise(N = n()) %>%
  arrange(desc(N)) %>%
  rename(LocationID = PULocationID) %>%
  left_join(taxi_zone_lookup, by = "LocationID")

# LocationID     N   Borough                         Zone
#         <int> <int>  <fctr>                       <fctr>
# 1        170  3735 Manhattan                  Murray Hill
# 2        161  2812 Manhattan               Midtown Center
# 3        230  2783 Manhattan    Times Sq/Theatre District
# 4        162  2719 Manhattan                 Midtown East
# 5        164  2635 Manhattan                Midtown South
# 6        163  1937 Manhattan                Midtown North
# 7        233  1748 Manhattan          UN/Turtle Bay South
# 8         10  1308    Queens                 Baisley Park
# 9        107  1266 Manhattan                     Gramercy
# 10        186  1185 Manhattan Penn Station/Madison Sq West

#top 10 zones of drop off
jfk_short_dis %>%
  filter(DOLocationID != 132) %>% 
  group_by(DOLocationID)%>%
  summarise(N = n()) %>%
  arrange(desc(N)) %>%
  rename(LocationID = DOLocationID) %>%
  left_join(taxi_zone_lookup, by = "LocationID")

#LocationID     N   Borough                      Zone
#         <int> <int>  <fctr>                    <fctr>
# 1        170  3601 Manhattan               Murray Hill
# 2        162  2630 Manhattan              Midtown East
# 3        164  2340 Manhattan             Midtown South
# 4        230  2293 Manhattan Times Sq/Theatre District
# 5        163  2009 Manhattan             Midtown North
# 6        161  1801 Manhattan            Midtown Center
# 7        233  1546 Manhattan       UN/Turtle Bay South
# 8         79  1402 Manhattan              East Village
# 9         48  1345 Manhattan              Clinton East
# 10        148  1329 Manhattan           Lower East Side

mean(jfk_short_dis$trip_distance)
#15.96464

#Newark-----------------------------------------------------------
ewr <- yellow_2016.08 %>%
  filter(RatecodeID == 3) %>%
  filter(payment_type != 3) %>%
  filter(trip_distance > 0) %>%
  filter(fare_amount > 0) %>%
  filter(PULocationID != DOLocationID) %>%
  mutate(est_fare = 2.5 + 0.5 * trip_distance * 5 + extra + 
           improvement_surcharge + mta_tax + tolls_amount,
         est_diff = est_fare - fare_amount)

#LaGuadia Airport
138

## Three Neward Airport Trips
17.5 + 2.5 + 0.5 * trip_distance * 5 + extra + improvement_surcharge + mta_tax + tolls_amount + tip_amont

## Four Westchester & Nassau
# Hard to measure
# need to calculate miles travel winthin and beyond City limit
#2.5 + 0.5 * trip_distance/5 + extra + improvement_surcharge + mta_tax + tolls_amount + tip_amont

NW <- yellow_2016.08 %>%
  filter(RatecodeID == 4)
NW %>%
  group_by(payment_type)%>%
  summarise(N = n()) %>%
  arrange(desc(N)) %>%
  mutate(prob = N/sum(N))
  
# payment_type     N        prob
# <int> <int>       <dbl>
#   1            1  3087 0.545406360
# 2            2  2401 0.424204947
# 3            3   139 0.024558304
# 4            4    33 0.005830389

#more likely to not pay or have illegal transaction

standard <- yellow_2016.08 %>%
  filter(RatecodeID == 1)
standard %>%
  group_by(payment_type)%>%
  summarise(N = n()) %>%
  arrange(desc(N)) %>%
  mutate(prob = N/sum(N))
# payment_type       N         prob
# <int>   <int>        <dbl>
#   1            1 6192695 6.416535e-01
# 2            2 3407411 3.530575e-01
# 3            3   38053 3.942846e-03
# 4            4   12991 1.346057e-03
# 5            5       1 1.036146e-07

## Five Other POints Ouside the City
# mutually agreed fare amount

#http://www.nyc.gov/html/tlc/html/passenger/taxicab_rate.shtml


# zero trip distance or very small value 
#pick up same as drop off