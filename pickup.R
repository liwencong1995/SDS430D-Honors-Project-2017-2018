#pick-up distribution

pickup_sum <- yellow_2016.08 %>%
  group_by(PULocationID) %>%
  summarise(pickup_num = n()) %>%
  arrange(desc(pickup_num)) %>%
  rename(LocationID = PULocationID) 

pickup_region <- left_join(pickup_sum, taxi_zone_lookup, by = "LocationID")

# LocationID pickup_num   Borough                         Zone
# <int>      <int>    <fctr>                       <fctr>
#   1        161     386388 Manhattan               Midtown Center
# 2        186     369236 Manhattan Penn Station/Madison Sq West
# 3        162     347765 Manhattan                 Midtown East
# 4        170     342365 Manhattan                  Murray Hill
# 5        234     339402 Manhattan                     Union Sq
# 6        237     333549 Manhattan        Upper East Side South
# 7        230     327979 Manhattan    Times Sq/Theatre District
# 8         48     319463 Manhattan                 Clinton East
# 9         79     308527 Manhattan                 East Village
# 10        236     281949 Manhattan        Upper East Side North

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

# LocationID dropoff_num   Borough                         Zone
# <int>       <int>    <fctr>                       <fctr>
# 1        161      387702 Manhattan               Midtown Center
# 2        170      338603 Manhattan                  Murray Hill
# 3        230      325090 Manhattan    Times Sq/Theatre District
# 4        162      322163 Manhattan                 Midtown East
# 5        237      294053 Manhattan        Upper East Side South
# 6        186      291651 Manhattan Penn Station/Madison Sq West
# 7        234      289236 Manhattan                     Union Sq
# 8        236      287215 Manhattan        Upper East Side North
# 9         48      278305 Manhattan                 Clinton East
# 10         79      254939 Manhattan                 East Village



