lyft_summary <- read.csv("~/Desktop/Honors Thesis/mysql/lyft_summary.csv")
green_summary <- read.csv("~/Desktop/Honors Thesis/mysql/green_summary.csv")
yellow_summary <- read.csv("~/Desktop/Honors Thesis/mysql/yellow_summary.csv")
yellow_new_summary <- read.csv("~/Desktop/Honors Thesis/mysql/yellow-new_summary.csv")
uber_summary <- read.csv("~/Desktop/Honors Thesis/mysql/uber_summary.csv")

library(dplyr)
lyft_summary <- lyft_summary%>%
  mutate(type = "lyft")

green_summary <- green_summary%>%
  mutate(type = "green")

yellow_summary <- bind_rows(yellow_summary, yellow_new_summary)
yellow_summary <- yellow_summary%>%
  mutate(type = "yellow") 
 
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

#add sum of taxi trips
taxi_sum <- summary %>%
  filter(type == "green" | type == "yellow")%>%
  group_by(the_year, the_month) %>%
  summarise(num_trips = sum(num_trips)) %>%
  mutate(type = "taxi") %>%
  mutate(year_month = paste0(the_year, "-", stringr::str_pad(the_month, 2, "left", "0"), "-01")) %>%
  filter(the_year != 0) %>%
  mutate(time = as.POSIXct(year_month))
combined <- bind_rows(combined, taxi_sum)
library(plotly)
p <- plot_ly(x = ~combined$time, y = ~combined$num_trips, mode = 'lines', split = combined$type)
p


write.csv(yellow_summary, "~/Desktop/yellow_summary.csv", row.names = FALSE)
write.csv(green_summary, "~/Desktop/green_summary.csv", row.names = FALSE)
write.csv(uber_summary, "~/Desktop/uber_summary.csv", row.names = FALSE)
write.csv(lyft_summary, "~/Desktop/lyft_summary.csv", row.names = FALSE)

#ggplot
#leaflet
#webshoot
#shiny
#save it as a image file

