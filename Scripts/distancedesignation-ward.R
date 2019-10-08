ward <- st_read(paste0(here(), "/data/Ward_boundaries/infuse_ward_lyr_2011"), "infuse_ward_lyr_2011")

  
   
  a <- list()
for (i in seq_len(nrow(ward))){
  a[[i]]<- SAC_centroid[which.min(st_distance(SAC_centroid, ward[i,])), ]
  a[[i]]$SAC_distance <- min(st_distance(SAC_centroid, ward[i, ]))
  print(i)
}
closest_dist_SAC <- do.call("rbind", a)



a <- list()
for (i in seq_len(nrow(ward))){
  a[[i]]<- SPA_centroid[which.min(st_distance(SPA_centroid, ward[i,])), ]
  a[[i]]$SPA_distance <- min(st_distance(SPA_centroid, ward[i, ]))
  print(i)
}
closest_dist_SPA <- do.call("rbind", a)


a <- list()
for (i in seq_len(nrow(ward))){
  a[[i]]<- ramsat_centroid[which.min(st_distance(ramsat_centroid, ward[i,])), ]
  a[[i]]$ramsat_distance <- min(st_distance(ramsat_centroid, ward[i, ]))
  print(i)
}
closest_dist_ramsat <- do.call("rbind", a)


###writeshapefiles

st_write(closest_dist_SPA, here(), "SAC_dist_ward.shp", driver="ESRI Shapefile")
st_write(closest_dist_SAC, paste0(here(),"/", "SPA_dist_ward_1.shp"), driver="ESRI Shapefile")
st_write(closest_dist_ramsat, paste0(here(),"/", "ratsar_dist_ward_1.shp"), driver="ESRI Shapefile")
