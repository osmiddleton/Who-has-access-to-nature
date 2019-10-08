library(stringr)


### unzipping code - incomplete

# # what are the ONS files available?
# loc = "data/ONS_zip/" # location of data files
# files = list.files(loc, pattern=".zip", full.names=T)
# 
# 
# #### UNZIP FILES
# 
# for (i in 1:length(files)){
#   file <- files[i]
#   num <- substr(file,start=16,stop=18)
#   unzip(file,files=list(paste("QS",num,"EWDATA01.csv",sep=""),
#                         paste("QS",num,"EWDATA02.csv",sep=""),
#                         paste("QS",num,"EWDATA03.csv",sep=""),
#                         paste("QS",num,"EWDATA04.csv",sep=""),
#                         paste("QS",num,"EWDATA05.csv",sep=""),
#                         paste("QS",num,"EWDATA06.csv",sep=""),
#                         paste("QS",num,"EWDESC0.csv",sep="")))
# }

## assumes that data is already unzipped

#### 1. READ DATA
# get list of wards in ONS data
ons_master <- read.csv("output/combined/ward_info.csv")



# # what are the ONS files available?
# loc <- "data/ONS_files/" # location of data files
# files <- list.files(loc, full.names=T)
# num <- unique(substr(files,start=18,stop=20))
# 
# 
# # read in ONS data from NORIS
# for (n in num){
#     # read for this data type
#   ons <- read.csv(paste("data/ONS_files/QS",num,"EWDATA01.csv",sep=""))
#   for (i in 2:6){
#     new_ons <- read.csv(paste("data/ONS_files/QS",num,"EWDATA0",i,".csv",sep=""))
#     ons <- rbind(ons,new_ons)
#   }
#   
#   ons_desc <- read.csv(paste("data/ONS_files/QS",num,"EWDESC0.csv",sep=""))
#   codes <- ons_desc$ColumnVariableCode
#   descs <- ons_desc$ColumnVariableDescription
#   num_data <- length(codes)
#   match(ons_master,ons)
# }

# age extraction
num <- 103
ons <- read.csv(paste("data/ONS_files/QS",num,"EWDATA01.csv",sep=""))
for (i in 2:6){
  new_ons <- read.csv(paste("data/ONS_files/QS",num,"EWDATA0",i,".csv",sep=""))
  ons <- rbind(ons,new_ons)
}

ages <- array(as.numeric(unlist(ons[,3:103])),c(length(ons$GeographyCode),101))
ages[is.na(ages)] <- 0
ons$mean_age <- rowSums((0:100)*ages)/rowSums(ages)
colnames(ons)[1] <- "ward"

ons_master <- left_join(ons_master,ons[,c("ward","mean_age")],by="ward")



# bedrooms per person
num <- 414
ons <- read.csv(paste("data/ONS_files/QS",num,"EWDATA01.csv",sep=""))
for (i in 2:6){
  new_ons <- read.csv(paste("data/ONS_files/QS",num,"EWDATA0",i,".csv",sep=""))
  ons <- rbind(ons,new_ons)
}
ons_desc <- read.csv(paste("data/ONS_files/QS",num,"EWDESC0.csv",sep=""))

rooms <- array(as.numeric(unlist(ons[,3:6])),c(length(ons$GeographyCode),4))
rooms[is.na(rooms)] <- 0
ons$mean_rooms <- rowSums(c(0.25,0.75,1.25,2)*rooms)/rowSums(rooms)
colnames(ons)[1] <- "ward"

ons_master <- left_join(ons_master,ons[,c("ward","mean_rooms")],by="ward")




# qualification
num <- 501
ons <- read.csv(paste("data/ONS_files/QS",num,"EWDATA01.csv",sep=""))
for (i in 2:6){
  new_ons <- read.csv(paste("data/ONS_files/QS",num,"EWDATA0",i,".csv",sep=""))
  ons <- rbind(ons,new_ons)
}
ons_desc <- read.csv(paste("data/ONS_files/QS",num,"EWDESC0.csv",sep=""))

qual <- array(as.numeric(unlist(ons[,c(3,4,5,7,8)])),c(length(ons$GeographyCode),5))
qual[is.na(qual)] <- 0
ons$mean_qual <- rowSums((0:4)*qual)/rowSums(qual)
colnames(ons)[1] <- "ward"

ons_master<-left_join(ons_master,ons[,c("ward","mean_qual")],by="ward")



# pop density
num <- 102
ons <- read.csv(paste("data/ONS_files/QS",num,"EWDATA01.csv",sep=""))
for (i in 2:6){
  new_ons <- read.csv(paste("data/ONS_files/QS",num,"EWDATA0",i,".csv",sep=""))
  ons <- rbind(ons,new_ons)
}
ons_desc <- read.csv(paste("data/ONS_files/QS",num,"EWDESC0.csv",sep=""))

colnames(ons)[1] <- "ward"
colnames(ons)[4] <- "pop_density"

ons_master<-left_join(ons_master,ons[,c("ward","pop_density")],by="ward")

write.csv(ons_master,"output/combined/wards_and_socioeconomic.csv")
