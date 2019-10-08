# ---- This is just a test ----

# Library
library(sf)
library(tidyverse)
library(sp)
library(vegan)
library(scico)
library(viridis)

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
wards <- st_transform(wards, st_crs(sr.updated))

# Either (1) merge by the location of the centroid of the ward to the SR grid cell...
ward.centroid.species.richness <- st_join(ward.centroid, sr.updated, join = st_intersects)

#...OR, (2) get the average of the grid cells which overlap with the ward shapefile
# test <- st_join(wards, sr.updated, join = st_intersects) # Oops, can't do this

st_geometry(ward.centroid.species.richness) <- NULL

colnames(test)
colnames(wards)

# Merge to the original wards shapefiles
colnames(wards)
colnames(ward.centroid.species.richness)

st_geometry(ward.centroid.species.richness) <- NULL

class(ward.centroid.species.richness)
class(wards)

ward.species.richness <- left_join(wards, ward.centroid.species.richness, by = c("geo_label" = "geo_label"))

colnames(ward.species.richness)

wsr <- ward.species.richness[c(11:22)]

st_geometry(wsr) <- NULL

# Scale the species richness
wsr[is.na(wsr)] <- 0
wsr <- as.data.frame(scale(wsr))

wsr <- rowSums(wsr)

str(ward.species.richness)

ward.species.richness$scaled.SR <- wsr

p <- ggplot() +
  geom_sf(data = ward.species.richness, aes(fill = scaled.SR, colour = scaled.SR)) +
  scale_fill_viridis() +
  scale_colour_viridis() +
  theme_bw()

ggsave("../scaled.sr.map.tiff", p, height = 8, width = 6, units = "in")


# ---- Biodiversity indices ----
wsr <- ward.species.richness[c(11:22)]

st_geometry(wsr) <- NULL

# Scale the species richness
wsr[is.na(wsr)] <- 0
wsr <- diversity(wsr, index = "shannon")


str(ward.species.richness)

ward.species.richness$shannon.biodiversity <- wsr

p <- ggplot() +
  geom_sf(data = ward.species.richness, aes(fill = shannon.biodiversity, colour = shannon.biodiversity)) +
  scale_fill_viridis() +
  scale_colour_viridis() +
  theme_bw()

ggsave("../shannon.bioD.map.tiff", p, height = 8, width = 6, units = "in")

# ---- Bird species richness
p <- ggplot() +
  geom_sf(data = ward.species.richness, aes(fill = Bird, colour = Bird)) +
  scale_fill_viridis() +
  scale_colour_viridis() +
  theme_bw()

ggsave("../bird.map.tiff", p, height = 8, width = 6, units = "in")

# ---- Plant species richness
p <- ggplot() +
  geom_sf(data = ward.species.richness, aes(fill = Vascular_plants, colour = Vascular_plants)) +
  scale_fill_viridis() +
  scale_colour_viridis() +
  theme_bw()

ggsave("../plant.map.tiff", p, height = 8, width = 6, units = "in")

# ---- Ladybirds species richness
p <- ggplot() +
  geom_sf(data = ward.species.richness, aes(fill = Ladybirds, colour = Ladybirds)) +
  scale_fill_viridis() +
  scale_colour_viridis() +
  theme_bw()

ggsave("../plant.map.tiff", p, height = 8, width = 6, units = "in")

# ---- Isopods species richness
p <- ggplot() +
  geom_sf(data = ward.species.richness, aes(fill = Isopods, colour = Isopods)) +
  scale_fill_viridis() +
  scale_colour_viridis() +
  theme_bw()

ggsave("../isopod.map.tiff", p, height = 8, width = 6, units = "in")


spa <- st_read("../Data", "SPA_dist_ward_1")
SAC <- st_read("../Data", "SAC_dist_ward")
ratsar <- st_read("../Data", "ratsar_dist_ward_1")

p <- ggplot() +
  geom_sf(data = spa, aes(fill = log10(SAC_dst), colour = log10(SAC_dst), size = 2)) +
  scale_fill_viridis() +
  scale_colour_viridis() +
  theme_bw()

ggsave("../averagedistance.map.tiff", p, height = 8, width = 6, units = "in")


