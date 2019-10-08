
# read in the green space data 

green <- st_read(here("Data"), layer = "os_greenspace")

# read in the centroid areas 
ward_cent <- st_read(here("Data", "output/ward_shapes"), layer = "ward_buffer_10sqkm")
ward_cent <- st_transform(ward_cent, st_crs(green))


#loop through this 
for (i in 1:nrow(ward_cent)){
  ex_ward <- ward_cent[i,]
  test <- st_intersection(green, ex_ward)
  green_ward <- sum(st_area(test))
  ward_cent$green_area[i] <- as.numeric(green_ward)
  print(i)
}
# crop the green space data to the ward centroid areas 
#ex_ward <- ward_cent[1,]

# calculating green space in each ward 
library(furrr)
plan(multiprocess)
test <- future_map_dbl(1:8527, function(x) {
  sum(st_area(st_intersection(green, ward_cent[x,])))
  })
# calculate % coverage

# covered area 
#green_ward <- sum(st_area(test))

#add to the master data 
#ward_cent$green_area[1,] <- green_ward