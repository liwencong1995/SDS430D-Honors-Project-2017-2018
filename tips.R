#tips
library(dplyr)
#tips by payment type
# only when paymen type is  credit card, the data indicate the correct tip amount
yellow_2016.08 %>%
  group_by(payment_type) %>%
  summarise(tip_mean = mean(tip_amount),
            tip_min = )

summary(yellow_2016.08 %>%
          filter(payment_type==2))

# high_tip <- yellow_2016.08 %>%
#   filter(tip_amount > fare_amount )
tip_region <- yellow_2016.08 %>%
  filter(fare_amount > 0) %>%
  filter(tip_amount > 0) %>%
  filter(payment_type == 1) %>%
  filter(tip_amount < fare_amount) %>%
  mutate(tip_perct = tip_amount/fare_amount) %>%
  group_by(PULocationID, DOLocationID) %>%
  summarise(avg_tip = mean(tip_perct), trips = n(),
            avg_dis = mean(trip_distance)) %>%
  filter(trips > 10) %>%
  arrange(desc(DOLocationID), desc(avg_tip)) %>%
  rename(LocationID = PULocationID) 
tip_region <- left_join(tip_region, taxi_zone_lookup, by = "LocationID")

#visualization
library(ggplot2)
quantile(tip_region$avg_tip)
# 0%        25%        50%        75%       100% 
# 0.07484415 0.19081151 0.20358737 0.21770189 0.38664646  

summary(tip_region$avg_tip)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.07484 0.19081 0.20359 0.20460 0.21770 0.38665

ggplot(data = tip_region, aes(x = avg_tip) ) +
  xlab("Tips, percent") +
  geom_histogram(binwidth = 0.005) + 
  geom_vline(xintercept = c(0.2), col = "red",linetype = "longdash") + 
  geom_vline(xintercept = c(0.20460), col = "blue",linetype = "longdash")

### find out the regions
# tip_high_region <- tip_region %>%
#   group_by(DOLocationID) %>%
#   top_n(10, avg_tip)
tip_high_region <- tip_region %>%
  filter(avg_tip > 0.20460)

tip_high_region_sum <- tip_high_region %>%
  group_by(LocationID) %>%
  summarise(freq = n(), zone_avg_tip = mean(avg_tip) ) %>%
  arrange(desc(zone_avg_tip)) %>%
  filter(freq >= 10) %>%
  left_join(taxi_zone_lookup, by = "LocationID")

write.csv(tip_high_region_sum, "~/Desktop/Honors Thesis/mysql/tip_high_region.csv")
View(tip_high_region_sum)

#pick up location is significant ---------------------------------
yellow_2016.08 <- yellow_2016.08 %>%
  filter(fare_amount > 0) %>%
  filter(tip_amount > 0) %>%
  filter(payment_type == 1) %>%
  filter(tip_amount < fare_amount) %>%
  mutate(tip_perct = tip_amount/fare_amount)
fit <- lm(tip_perct ~ PULocationID + trip_distance ,data = yellow_2016.08)
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
