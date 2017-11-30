lyft_summary <- read.csv("~/Desktop/lyft_summary.csv")
green_summary <- read.csv("~/Desktop/green_summary.csv")
yellow_summary <- read.csv("~/Desktop/yellow_summary.csv")
uber_summary <- read.csv("~/Desktop/uber_summary.csv")

library(dplyr)
lyft_summary <- lyft_summary%>%
  mutate(type = "lyft")

green_summary <- green_summary%>%
  mutate(type = "green")

yellow_summary <- yellow_summary%>%
  mutate(type = "yellow")

uber_summary <- uber_summary%>%
  mutate(type = "uber")

summary <- bind_rows(lyft_summary, green_summary, yellow_summary, uber_summary) %>%
  mutate(year_month = paste0(the_year, "-", stringr::str_pad(the_month, 2, "left", "0"), "-01")) %>%
  filter(the_year != 0) %>%
  mutate(time = as.POSIXct(year_month))

library(plotly)
p <- plot_ly(x = ~summary$time, y = ~summary$num_trips, mode = 'lines', split = summary$type)
p

