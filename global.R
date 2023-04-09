library(dplyr)
library(plotly)
library(ggplot2)
library(ggtext)
library(maps)
library(sf)

?human_stampedes

my_data <- read.csv("human_stampedes.csv")

my_data <- human_stampedes
#Structure
my_data %>%
  str()
#summary 
my_data %>%
  summary()
#head
my_data %>%
  head()
#Assigning rowname to object 
country = rownames(my_data)

my_data = my_data%>%
  mutate(country = Country)

str(my_data)

c1 = my_data %>% 
  select(-"Country") %>% 
  names()

# Column names without Country and Number.of.Deaths This will be used in the selectinput for choices in the shinydashboard
c2 = my_data %>% 
  select(-"Country", -"Number.of.Deaths") %>% 
  names()



country_Map <- map("world")
my_data1 <- my_data %>%
  mutate(Country = tolower(Country))

# merged = right_join(my_data1, country_Map, by = c ("Country" = "region"))

# 
cy = data.frame(abb = country, cyname=tolower(country))

# new_join = left_join(merged, cy, by=c("Country" = "cyname"))
merged_sf <- st_as_sf(merged, coords = c("long", "lat"), crs = st_crs(country_Map))

new_join <- left_join(merged_sf, cy, by = c("Country" = "cyname"))

