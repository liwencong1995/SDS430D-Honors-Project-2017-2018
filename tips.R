#tips
library(dplyr)
#yellow_2016.08 <- yellow_2016.08_cleaned
library(nyctaxi)

#Load geographic information
data("taxi_zone_lookup")
data("taxi_zones")
View(taxi_zone_lookup)
taxi_zone_lookup$LocationID <- as.factor(taxi_zone_lookup$LocationID)


#tips by payment type
# only when paymen type is  credit card, the data indicate the correct tip amount
yellow_2016.08 %>%
  group_by(payment_type) %>%
  summarise(tip_mean = mean(tip_amount),
            tip_min = min(tip_amount),
            tip_max = max(tip_amount))

# # A tibble: 5 x 4
# payment_type      tip_mean tip_min tip_max
# <int>         <dbl>   <dbl>   <dbl>
#   1            1  2.722735e+00  -16.00  999.99
# 2            2  8.598192e-05    0.00   71.01
# 3            3 -1.328520e-03  -19.32   10.00
# 4            4 -7.190188e-03  -40.00    3.63
# 5            5  0.000000e+00    0.00    0.00

#filter out the unwanted observations
yellow_2016.08_tip <- yellow_2016.08 %>%
  filter(fare_amount > 0) %>%
  filter(tip_amount > 0) %>%
  filter(payment_type == 1) %>%
  filter(tip_amount < fare_amount)

#Find the regions that offer the largest tip-----------------------
yellow_2016.08_tip <- yellow_2016.08_tip %>%
  mutate(tip_perct = tip_amount/fare_amount)

#summary
quantile(tip_region$avg_tip)
# 0%          25%          50%          75%         100% 
# 0.0001408451 0.1810815868 0.2043803873 0.2231832030 0.9973913043 

#visualization of individual trips
library(ggplot2)
tip_individual <- ggplot(data = yellow_2016.08_tip, aes(x = tip_perct) ) +
  xlab("Tips, percent") +
  geom_histogram(binwidth = 0.005) + 
  geom_vline(xintercept = c(0.20), col = "red",linetype = "longdash") + 
  geom_vline(xintercept = c(0.2043), col = "blue",linetype = "longdash") +
  geom_vline(xintercept = c(0.25), col = "green",linetype = "longdash") +
  geom_vline(xintercept = c(0.28), col = "yellow",linetype = "longdash")
tip_individual

#do longer trips result in higher tip percent?
tip_distance <- lm(tip_perct ~ trip_distance, data = yellow_2016.08_tip)
summary(tip_distance)

#not significant
# Coefficients:
#   Estimate Std. Error  t value Pr(>|t|)    
# (Intercept)    2.189e-01  2.812e-05 7785.080   <2e-16 ***
#   trip_distance -4.146e-09  8.729e-09   -0.475    0.635 

#transform location id into factors
# str(yellow_2016.08_tip)
# yellow_2016.08_tip$PULocationID <- as.factor(yellow_2016.08_tip$PULocationID)
# yellow_2016.08_tip$DOLocationID <- as.factor(yellow_2016.08_tip$DOLocationID)

#by controlling pickup and dropoff locations, does trip distance have any impact on tip?
#takes forever
tip_distance_2 <- lm(tip_perct ~ trip_distance + PULocationID + DOLocationID, data = yellow_2016.08_tip)
summary(tip_distance_2)

# so try agregated region-level data
#aggregated level tip amount
tip_region <- yellow_2016.08_tip  %>%
  group_by(PULocationID, DOLocationID) %>%
  summarise(avg_tip = mean(tip_perct), trips = n(),
            avg_dis = mean(trip_distance)) %>%
  filter(trips > 10) %>%
  arrange(desc(avg_tip)) %>%
  rename(LocationID = PULocationID) %>%
  left_join(taxi_zone_lookup, by = "LocationID")

# #by controlling pickup and dropoff locations, does trip distance have any impact on tip?
# #takes forever
# tip_distance_3 <- lm(avg_tip ~ avg_dis + LocationID + DOLocationID, data = tip_region)
# summary(tip_distance_3)
# 
# #by controlling pickup locations, does trip distance have any impact on tip?
# #takes forever
# tip_distance_4 <- lm(avg_tip ~ avg_dis + LocationID, data = tip_region)
# summary(tip_distance_4)
# 
# #by controlling dropoff locations, does trip distance have any impact on tip?
# #takes forever
# tip_distance_5 <- lm(avg_tip ~ avg_dis + DOLocationID, data = tip_region)
# summary(tip_distance_5)
# #AVERAGE DISTANCE DOES NOT MATTER


#visualization region level
region_vis <- ggplot(data = tip_region, aes(x = avg_tip) ) +
  xlab("Tips, percent") +
  geom_histogram(binwidth = 0.005) + 
  geom_vline(xintercept = c(0.20), col = "red",linetype = "longdash") +
  geom_vline(xintercept = c(0.25), col = "green",linetype = "longdash") +
  geom_vline(xintercept = c(0.28), col = "yellow",linetype = "longdash") + 
  scale_x_continuous(limits = c(0, 0.5))
region_vis

LocationID
LocationID

#aggregated pick
tip_pickup <- tip_region %>%
  group_by(LocationID) %>%
  summarise(avg_tip = mean(avg_tip), num_trips=sum(trips)) %>%
  left_join(taxi_zone_lookup, by = "LocationID") %>%
  arrange(desc(avg_tip)) %>%
  filter(Zone != "Unknown")

str(taxi_zone_lookup)
str(tip_region)
taxi_zone_lookup$LocationID <- as.character()

ggplot(data = tip_pickup, aes(x = num_trips)) +
  geom_histogram(binwidth = 100)

quantile(tip_pickup$num_trips, probs = seq(0,1,0.1))
summary(tip_pickup$num_trips)
sd(tip_pickup$num_trips)
23380 - 52793.89
pickup_zone <- tip_pickup %>%
  filter(num_trips >= 1000) %>%
  arrange(desc(avg_tip))


#write.csv(tip_pickup, "/Users/priscilla/Desktop/Honors Thesis/thesis/index/data/tip_pickup.csv")

tip_and_trip <- lm(avg_tip ~ num_trips, data = pickup_zone)
summary(tip_and_trip)

region_pickup_vis <- region_vis %+% tip_pickup
region_pickup_vis

#aggregated dropoff
tip_dropoff <- tip_region %>%
  group_by(DOLocationID) %>%
  summarise(avg_tip = mean(avg_tip)) %>% 
  rename(LocationID = DOLocationID) %>%
  left_join(taxi_zone_lookup, by = "LocationID")

region_dropoff_vis <- region_pickup_vis %+% tip_dropoff
region_dropoff_vis

mean(tip_region$avg_tip)
mean(tip_pickup$avg_tip)
mean(tip_dropoff$avg_tip)

### find out the regions
tip_high_region <- tip_region %>%
  filter(avg_tip > 0.2)

#among all the avg_tip > 0.2 regions
tip_high_region_pickup <- tip_high_region %>%
  group_by(LocationID) %>%
  summarise(freq = n(), zone_avg_tip = mean(avg_tip) ) %>%
  arrange(desc(zone_avg_tip)) %>%
  filter(freq >= 50) %>%
  left_join(taxi_zone_lookup, by = "LocationID")

tip_high_region_dropoff <- tip_high_region %>%
  group_by(DOLocationID) %>%
  summarise(freq = n(), zone_avg_tip = mean(avg_tip) ) %>%
  arrange(desc(zone_avg_tip)) %>%
  filter(freq >= 50) %>%
  rename(LocationID = DOLocationID) %>%
  left_join(taxi_zone_lookup, by = "LocationID")

#problem with longer trip usually have higher tip percent?

# how do taxi driver get paid
# one pic for fare amount
# one pick for tip amount, percetage
# fare per hour
# take the fare and divide by time, cost of time, 
# think about the locations, pickup and drop off
# how upset or excited a cab triver would be when someone
# if tell them where they are going

#how about taking out the ones that are going to the airport?
standard_fare <- yellow_2016.08_tip %>%
  filter(RatecodeID == 1)

standard_tip_region <- standard_fare  %>%
  group_by(PULocationID, DOLocationID) %>%
  summarise(avg_tip = mean(tip_perct), trips = n(),
            avg_dis = mean(trip_distance)) %>%
  filter(trips > 10) %>%
  arrange(desc(avg_tip)) %>%
  rename(LocationID = PULocationID) %>%
  left_join(taxi_zone_lookup, by = "LocationID")

tip_distance_6 <- lm(avg_tip ~ avg_dis, data = standard_tip_region)
summary(tip_distance_6)

standard_region_vis <- ggplot(data = standard_tip_region, aes(x = avg_tip) ) +
  xlab("Tips, percent") +
  geom_histogram(binwidth = 0.005) + 
  geom_vline(xintercept = c(0.20), col = "red",linetype = "longdash") +
  geom_vline(xintercept = c(0.25), col = "green",linetype = "longdash") +
  geom_vline(xintercept = c(0.28), col = "yellow",linetype = "longdash")
standard_region_vis

### find out the regions
standard_tip_high_region <- tip_region %>%
  filter(avg_tip > 0.2)

#among all the avg_tip > 0.2 regions
standard_tip_high_region_pickup <- tip_high_region %>%
  group_by(LocationID) %>%
  summarise(freq = n(), zone_avg_tip = mean(avg_tip) ) %>%
  arrange(desc(zone_avg_tip)) %>%
  filter(freq >= 50) %>%
  left_join(taxi_zone_lookup, by = "LocationID")

standard_tip_high_region_dropoff <- tip_high_region %>%
  group_by(DOLocationID) %>%
  summarise(freq = n(), zone_avg_tip = mean(avg_tip) ) %>%
  arrange(desc(zone_avg_tip)) %>%
  filter(freq >= 50) %>%
  rename(LocationID = DOLocationID) %>%
  left_join(taxi_zone_lookup, by = "LocationID")







#how about the ones going to different residential area?



write.csv(tip_high_region_sum, "~/Desktop/Honors Thesis/mysql/tip_high_region.csv")
View(tip_high_region_sum)

#pick up location is significant ---------------------------------
yellow_2016.08 <- yellow_2016.08 %>%
  filter(fare_amount > 0) %>%
  filter(tip_amount > 0) %>%
  filter(payment_type == 1) %>%
  filter(tip_amount < fare_amount) %>%
  mutate(tip_perct = tip_amount/fare_amount)
###fit <- lm(tip_perct ~  + trip_distance ,data = yellow_2016.08)
summary(fit)

# Coefficients:
#   Estimate Std. Error  t value Pr(>|t|)    
# (Intercept)    2.171e-01  7.461e-05 2909.718   <2e-16 ***
#   PULocationID   1.111e-05  4.275e-07   25.999   <2e-16 ***
#   trip_distance -4.247e-09  8.728e-09   -0.487    0.627
# Voided trip-----------------------------------------------------
yellow_2016.08 %>%
  filter(payment_type == 6)

# no charge
no_charge <- yellow_2016.08 %>%
  filter(payment_type == 3)
no_charge%>%
  group_by(RatecodeID) %>%
  summarise(N = n()) %>%
  mutate(prob = N/sum(N)) %>%
  arrange(desc(N))

# RatecodeID     N         prob
# <int> <int>        <dbl>
# 1          1 38053 0.8833511305
# 2          2  2163 0.0502112447
# 3          5  1891 0.0438971169
# 4          3   770 0.0178745531
# 5          4   139 0.0032267050
# 6          6    43 0.0009981893
# 7         99    19 0.0004410604

#higher probability no charge for the ones that are going to jfk/newark
mean(no_charge$fare_amount)
#12.53721
max(no_charge$fare_amount)
#22459.24
hist(no_charge$fare_amount, breaks = 50)

#charge
charge <- yellow_2016.08 %>%
  filter(payment_type != 3)
charge%>%
  group_by(RatecodeID) %>%
  summarise(N = n()) %>%
  mutate(prob = N/sum(N)) %>%
  arrange(desc(N))
# RatecodeID       N         prob
# <int>   <int>        <dbl>
# 1          1 9613098 9.710999e-01
# 2          2  229352 2.316878e-02
# 3          5   31874 3.219861e-03
# 4          3   19148 1.934301e-03
# 5          4    5521 5.577227e-04
# 6         99     141 1.424360e-05
# 7          6      51 5.151939e-06

#https://github.com/pavelk2/NYC-taxi-tips



#---------------------------------SHAPEFILE-----------------------
require(rgdal)
View(taxi_zones)
shape <- readOGR()
require(plyr)
require(maptools)
require(ggmap)

# https://www.r-bloggers.com/basic-mapping-and-attribute-joins-in-r/

str(tip_pickup)
tip_pickup$LocationID <- as.factor(tip_pickup$LocationID)

#str(taxi_zones)
newobj <- merge(taxi_zones, tip_pickup, by.x = "LocationID", by.y = "LocationID")
names(taxi_zones)
names(pickup_zone)
plot(newobj, col = newobj$num_trips )

summary(taxi_zones)
nrow(taxi_zones)
str(taxi_zones[1,])
head(taxi_zones@data)

cols <- brewer.pal(n = 4, name = "Greys")
lcols <- cut(newobj$num_trips,
             breaks = quantile(newobj$num_trips, na.rm = TRUE),
             labels = cols)
plot(newobj, col = as.character(lcols))
