# calculating distances from ward centroids to park centroids 
library(sf)
library(here)
library(stringr)
library(dplyr)
wards <- st_read(dsn= here("Data", "Ward_boundaries/infuse_ward_lyr_2011/"), layer = "infuse_ward_lyr_2011")

#plot(wards)

#W_ward_codes <- as.data.frame(dplyr::select(wards, geo_code))

#W_ward_codes <- select(wards,geo_code) %>% str_detect()

EW_wards <- wards %>% filter(str_detect(geo_code, "^E.*") | str_detect(geo_code, "^W.*"))

# get the centroids for the wards 
EW_wards$Centroids <- st_centroid()
# aggregate to county level


#greenspace areas 
greens <- st_read(dsn = here("Data", "OS_Greenspace/OS Greenspace (GML) GB/"), 
                  layer = "OSOpenGreenspace_GB.gml")

greens <- read.graph(here("Data", "OS_Greenspace/OS Greenspace (GML) GB", "OSOpenGreenspace_GB.gml"), format = "gml")
