####Hackathon Cristina Martin 
#Challenge acess to nature
#Get centroid of protected sites in England and Wales only:
#
#
#
library(sf)
library(here)
library(dplyr)
#######SPA:

#read the file
protectedSitesSPA <- st_read(paste0(here(), "/Repositories/HackathonAcces/data/JNCC_protected_areas/UK_SPA_GIS_20190326"), "GB_SPA_OSGB36_20190326")
head(protectedSitesSPA)
#Select only the England and Wales:
  #read the England and wales only boundary from isabel
EnglandWales <- st_read(paste0(here(), "/Repositories/HackathonAcces/data/eng_wales"), "British_Isles_by_DA")
plot(EnglandWales)


SPA_E_W <- st_intersection(EnglandWales, protectedSitesSPA)
head(SPA_E_W)

########SAC:

#read the file
protectedSitesSAC <- st_read(paste0(here(), "/Repositories/HackathonAcces/data/JNCC_protected_areas/UK_SAC_GIS_20190326"), "GB_SAC_OSGB36_20190403")
head(protectedSitesSAC)
SAC_E_W_E <- protectedSitesSAC[protectedSitesSAC$Country == "E", ]
SAC_E_W_W <- protectedSitesSAC[protectedSitesSAC$Country == "W", ]
SAC_E_W <- rbind(SAC_E_W_E, SAC_E_W_W)



################RAMSAR

protectedSitesRAMSAR <- st_read(paste0(here(), "/Repositories/HackathonAcces/data/JNCC_protected_areas/UK_RAMSAR_20181205_BNG"), "UK_RAMSAR_20181205_BNG")
head(protectedSitesRAMSAR)
ramsar_E_W <- protectedSitesRAMSAR %>% filter(., Country == "E" | Country == "W")


#####Centroids:
SPA_centroid<- st_centroid(SPA_E_W)
SAC_centroid <- st_centroid(SAC_E_W)
ramsat_centroid <- st_centroid(ramsar_E_W)
