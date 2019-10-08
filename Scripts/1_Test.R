# ---- This is just a test ----

# Library
library(sf)
library(tidyverse)
library(sp)

# Load ward data
wards <- st_read("../Data/Access_to_nature/Ward_boundaries/infuse_ward_lyr_2011", "infuse_ward_lyr_2011")
str(wards)

# Plot the map
# ggplot() +
#   geom_sf(data = wards, fill = "grey") +
#   theme_bw()

# My basic species richness
sr.2000 <- read.csv("../Data/Access_to_nature/Species_richness/SpeciesRichness/Species_richness_2000.csv")
str(sr.2000)

sr.2000.grids <- read.csv("./Data/Species_richness_2000.csv")
str(sr.2000.grids)
class(sr.2000.grids)

grids.10k <- st_read("./Data", "10km_grid_region")
head(grids.10k)
str(grids.10k)

sr.updated <- dplyr::left_join(grids.10k, sr.2000.grids, by = c("TILE_NAME" = "Location"))
class(sr.updated)

# Get ward centroids
ward.centroid <- st_centroid(wards)
plot(ward.centroid)

# Match CRS between ward centroid and species richness
ward.centroid <- st_transform(ward.centroid, st_crs(sr.updated))
ward.centroid.species.richness <- st_join(ward.centroid, sr.updated, join = st_intersects)

st_geometry(ward.centroid.species.richness) <- NULL

colnames(test)
colnames(wards)

# Merge to the original wards shapefiles
ward.species.richness <- dplyr::left_join(wards, ward.centroid.species.richness, by=("geo_label" = "geo_label"))
colnames(ward.species.richness)

wsr <- ward.species.richness[c(11:22)]

st_geometry(wsr) <- NULL
wsr[is.na(wsr)] <- 0

wsr <- rowSums(wsr)

str(ward.species.richness)

ward.species.richness$SR <- wsr

p <- ggplot() +
  geom_sf(data = ward.species.richness, aes(fill = SR, colour = SR)) +
  theme_bw()

ggsave("../sr.map.tiff", p, height = 8, width = 6, units = "in")
