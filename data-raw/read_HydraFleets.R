# reads in fleet structure by gear type
read_HydraFleets <- function() {
  fleets <- read.csv("data/HydraFleets.csv",header=TRUE,row.names = "names")
  fleets[fleets==""] <- NA
  fleets <- apply(fleets,2,sort,na.last=NA)
  
  return(fleets)
}


