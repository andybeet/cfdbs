# convert all csv data to .RrData to be used in package

convert_to_Rdata <- function() {

  # saves gear type by fleet in 2 formats. Cluster and linear
  fleets <- list()
  fleetsD <- read.csv("data-raw/Fleets_byGear.csv",header=TRUE)
  fleets$data <- apply(fleetsD,2,sort,na.last=NA) # cluster
  fleets$names <- names(fleetsD) #linear
  fleets$codes <- sort(unique(as.vector(sapply(fleetsD,as.numeric))),na.last=NA) #linear
  fleets$descriptions <- NULL
  save(fleets,file="data/fleets.RData")

  # saves statistical areas by EPU in 2 formats, Cluster and linear

  EPUs <- list()
  EPU_data <- read.csv("data-raw/EPUs_StatAreas.csv",header=TRUE,stringsAsFactors = FALSE)
  statAreas <- apply(apply(EPU_data[2:dim(EPU_data)[1],],2,as.numeric),2,sort,na.last=NA)
  EPUs$data <- statAreas
  EPUs$names <- names(EPU_data)
  EPUs$codes <- sort(unique(as.numeric(simplify2array(EPU_data[2:dim(EPU_data)[1],]))),na.last=NA)
  EPUs$descriptions <- EPU_data[1,]

  save(EPUs,file="data/EPUs.RData")



}
