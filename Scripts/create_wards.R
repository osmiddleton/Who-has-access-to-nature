#### reads in ward shape files and outputs centroids and buffer zones

#### 0. DEPENDENCIES
library(sf)
library(sp)


#### 1. DATA READ
# read in shape data for wards
wards = readOGR("data/ward_shapefiles/infuse_ward_lyr_2011.shp")
wards = st_as_sf(wards,coords=c("x","y"))
wards = st_transform(wards, "+proj=utm +zone=42N +datum=WGS84 +units=km")


# read in ONS data from NORIS
ons <- read.csv("data/ONS_files/QS103EWDATA01.csv")
for (i in 2:6){
  new_ons <- read.csv(paste("data/ONS_files/QS103EWDATA0",i,".csv",sep=""))
  ons <- rbind(ons,new_ons)
}


#### 2. DATA EXTRACT
# get list of wards in ONS data
ons <- unique(ons[!ons$QS103EW0001=="..","GeographyCode"])
# restrict to wards within this data
wards <- wards[wards$geo_code %in% ons,]




#### 3. CALCULATIONS

# get the centroid
ward.centroid = st_centroid(wards)

# function to create buffer zone containing the centroid
buffer_create <- function(wards,area){
  radius <- sqrt(area/pi)
  ward.buffer <- st_buffer(ward.centroid,dist=radius)
  return(ward.buffer) 
}

ward.buffer.10sqkm <- buffer_create(wards,10^2)
ward.buffer.10sqkm$area <- st_area(ward.buffer.10sqkm)

# calculate area of wards
wards.area = st_area(wards)

#### 4. CREATE DATAFRAME FOR COMPILATION
ward_df <- data.frame(ward=wards$geo_code,area=wards.area,name=wards$geo_label)


#### 5. OUTPUT EVERYTHING
write.csv(ward_df,"output/combined/ward_info.csv")
st_write(ward.centroid,"output/ward_shapes/ward_centroid.shp")
st_write(ward.buffer.10sqkm,"output/ward_shapes/ward_buffer_10sqkm.shp")


