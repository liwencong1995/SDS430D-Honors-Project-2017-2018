lyft_summary <- read.csv("~/Desktop/lyft_summary.csv")
green_summary <- read.csv("~/Desktop/green_summary.csv")
yellow_summary <- read.csv("~/Desktop/yellow_summary.csv")
uber_summary <- read.csv("~/Desktop/uber_summary.csv")

library(dplyr)
lyft_summary <- lyft_summary%>%
  mutate(type = "lyft")

green_summary <- green_summary%>%
  mutate(type = "green") %>%
  filter(the_year > 2013)

yellow_summary <- yellow_summary%>%
  mutate(type = "yellow") %>%
  filter(the_year > 2013)

uber_summary <- uber_summary%>%
  mutate(type = "uber")

summary <- bind_rows(lyft_summary, green_summary, yellow_summary, uber_summary) %>%
  mutate(year_month = paste0(the_year, "-", stringr::str_pad(the_month, 2, "left", "0"), "-01")) %>%
  filter(the_year != 0) %>%
  mutate(time = as.POSIXct(year_month))

all_sum <- summary %>%
  group_by(the_year, the_month) %>%
  summarise(num_trips = sum(num_trips)) %>%
  mutate(type = "all") %>%
  mutate(year_month = paste0(the_year, "-", stringr::str_pad(the_month, 2, "left", "0"), "-01")) %>%
  filter(the_year != 0) %>%
  mutate(time = as.POSIXct(year_month))

combined <- bind_rows(summary, all_sum)

#----------
taxi_sum <- summary %>%
  filter(type == "green" | type == "yellow")%>%
  group_by(the_year, the_month) %>%
  summarise(num_trips = sum(num_trips)) %>%
  mutate(type = "taxi") %>%
  mutate(year_month = paste0(the_year, "-", stringr::str_pad(the_month, 2, "left", "0"), "-01")) %>%
  filter(the_year != 0) %>%
  mutate(time = as.POSIXct(year_month))
combined <- bind_rows(combined, taxi_sum)
p <- plot_ly(x = ~combined$time, y = ~combined$num_trips, mode = 'lines', split = combined$type)
p


#ggplot
#leaflet
#webshoot
#shiny
#save it as a image file

