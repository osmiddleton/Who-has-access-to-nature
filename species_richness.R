library(sf)
library(dplyr)
library(here)

species_data <- read.csv(here("Species_richness_2000.csv"))

grid <- st_read(here("10km_grid_region.shp"))

species_grid <- left_join(grid, species_data, by=c("TILE_NAME"="Location"))