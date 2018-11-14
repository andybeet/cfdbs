

# reads in statistical areas from a file and returns statareas for specified EPU or combinations
read_statisticalAreas <- function(chosenEPU="all",collapsed="yes") {
  EPUs <- read.csv("EPUs_StatAreas.csv",header=TRUE,stringsAsFactors = FALSE)
  dimV <- dim(EPUs)
  statAreas <- NULL
  EPU_Areas <- EPUs[2:dimV[1],]
  EPU_areaCodes <- NULL

  if (any(chosenEPU == names(EPUs))) {
    # select stat areas for region and sort
    #statAreas <- as.numeric(levels(EPU_Areas[[chosenEPU]])[EPU_Areas[[chosenEPU]]])
    statAreas <- as.numeric(EPU_Areas[[chosenEPU]])
    statAreas <- sort(statAreas,na.last=NA)
    EPU_names <- chosenEPU
    EPU_description <- as.character(EPUs[[chosenEPU]][1])
  } else if ((tolower(chosenEPU) == "all") & (collapsed == "yes") ){
    # unique sorted list of all areas
    for (iall in 1:length(names(EPUs))) {
      #rareas <- as.numeric(levels(EPU_Areas[[iall]])[EPU_Areas[[iall]]])
      rareas <- as.numeric(EPU_Areas[[iall]])
      statAreas <- c(sort(rareas,na.last=NA),statAreas)
      EPU_names <- names(EPUs)
      EPU_description <- EPUs[1,]
    }

  } else if ((tolower(chosenEPU) == "all") & (collapsed == "no") ){
    statAreas <- apply(apply(EPUs[2:dimV[1],],2,as.numeric),2,sort,na.last=NA)
    EPU_names <- names(EPUs)
    EPU_description <- EPUs[1,]
    EPU_areaCodes <- sort(unique(as.numeric(simplify2array(EPUs[2:dimV[1],]))),na.last=NA)

  } else {
    stop(paste("Specified region does not exist. Options = ",toString(names(EPUs)),". CALL FROM ->",match.call()[[1]]),".R")
  }



    return(list(EPU_names=EPU_names,EPU_description=EPU_description,area=statAreas,EPU_areaCodes=EPU_areaCodes))
}
