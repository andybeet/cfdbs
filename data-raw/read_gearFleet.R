# reads in fleet structure by gear type
read_gearFleet <- function(chosenFleet="all",collapsed = "yes") {
  fleets <- read.csv("Fleets_byGear.csv",header=TRUE)
  fleetData <- NULL
  names(fleets) <- tolower(names(fleets))
  chosenFleet <- tolower(chosenFleet)
  #chosenFleet <- tolower(chosenFleet)
  # make data more usable here

  if (length(chosenFleet) > 1) { #more than one fleet required
    if (!(length(intersect(chosenFleet,names(fleets))) == length(chosenFleet))) {
      stop(paste("Specified Fleet type does not exist. Options = ",toString(names(fleets)),". CALL FROM ->",match.call()[[1]]),".R")
    }
    fleetData <- lapply(chosenFleet,FUN= function(x) sort(as.numeric(fleets[[x]]),na.last = NA))
    names(fleetData) <- chosenFleet
    fleetName <- chosenFleet
    if (collapsed == "yes") {
      fleetData <- unlist(fleetData)
    }
  } else {

  if (any(chosenFleet == names(fleets))) {
    # select fleet and sort
    #statAreas <- as.numeric(levels(EPU_Areas[[chosenEPU]])[EPU_Areas[[chosenEPU]]])
    fleetData <- as.numeric(fleets[[chosenFleet]])
    fleetData <- sort(fleetData,na.last=NA)
    fleetName <- chosenFleet
  } else if ((chosenFleet == "all") & (collapsed == "yes")) {
    # unique sorted list of all areas
    fleetData <- sort(unique(as.vector(sapply(fleets,as.numeric))),na.last=NA)
    fleetName <- names(fleets)
  } else if ((chosenFleet == "all") & (collapsed == "no")) {
      fleetData <- apply(fleets,2,sort,na.last=NA)
      fleetName <- names(fleets)
  } else {
    stop(paste("Specified Fleet type does not exist. Options = ",toString(names(fleets)),". CALL FROM ->",match.call()[[1]]),".R")
  }
  }

  return(list(negear2=fleetData,fleet_names=fleetName))
}


