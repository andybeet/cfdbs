#' Extract landings data from Adios!
#'
#'Extract landings information (\code{trplndlb},\code{trplivlb},\code{spplndlb},\code{spplivlb}) in lbs from the databse ADIOS! This function requires no knowledge of sql.
#'NOTE: Eventually hope to pull \code{numlen}, and \code{len} also. Not in ADIOS
#'For direct sql usage please see \code{\link{get_anything_sql}} function
#'
#'
#'@param channel an RODBC object (see \code{\link{connect_to_database}})
#'@param areas a numeric vector of statistical areas (area)
#'@param gears a numerical vector of gear types (negear2)
#'@param years a numerical vector containing the years to search over
#'@param tonnage a numerical vector of tonnage classes (toncl2) (1 - 8) where 1 = 10-19 tons, 2 = 20-29 tons etc
#'@param species a numerical list of species (nespp3)
#'
#'@return A list is returned:
#'
#'   \code{data}      containing the result of the data pull
#'
#'   \code{sql}  the resulting sql statement based on user input
#'
#'   \code{colNames} a vector of the table's column names
#'
#'@section Reference:
#'Use the data dictionary (\url{http://nova.nefsc.noaa.gov/datadict/}) for field name explanations
#'
#'@section Warning:
#'You will need to obtain read only privilages to access ADIOS!
#'The ADIOS database contains 35 million records. If you try to pull the entire database it is likely you will run out of memory.
#'
#'@seealso \code{\link{connect_to_database}}, \code{\link{get_anything_sql}}
#'
#'
#'@examples
#'\dontrun{
#'
#' # extracts landings for cod (081) in area 500 for ton class >=10 by <20 using  gear types (1,2,10)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#'
#' get_landings(channel,area=c(500,600),gear=c(1,2,10),year=c(1999),tonnage=c(1),species=81)
#'}
#'
#'@export
#'

get_landings <- function(channel,area="all",gear="all",year=1994,tonnage="all",species="all"){

  # create an SQL query to extract all relavent data from tables
  # this will require the user to enter statistical area, EPU, fleet characteristics, species etc.

  # list of strings to build where clause in sql statement
  whereVec <- list()

  whereVec[[1]] <-  createString(itemName="area",area,convertToCharacter=TRUE,numChars=3)
  whereVec[[2]] <-  createString(itemName="negear2",gear,convertToCharacter=TRUE,numChars=2)
  whereVec[[3]] <-  createString(itemName="nespp3",species,convertToCharacter=TRUE,numChars=3)
  whereVec[[4]] <-  createString(itemName="year",year,convertToCharacter=TRUE,numChars=4)
  whereVec[[5]] <-  createTonnageString(itemName="toncl2",tonnage)

  # build where clause of SQL statement based on input above
  whereStr <- "where"
  for (item in whereVec) {
    if (is.null(item)) {next}
    if (which(item == whereVec) == length(whereVec)) {
      whereStr <- paste(whereStr,item)
      next
    }
    whereStr <- paste(whereStr,item,"and")
  }


  #  need to have length and numlen in ADIOS for comlens script to work

  # eventually user will be able to pass these variables
  sqlStatement <- "select year, month, day, negear2, toncl2, nespp3,nespp4, area, ntrips, mesh,df, da , spplndlb,spplivlb, trplndlb,trplivlb  
                    from stockeff.mv_cf_landings"

  sqlStatement <- paste(sqlStatement,whereStr)

  # call database
  query <- RODBC::sqlQuery(channel,sqlStatement,errors=TRUE,as.is=TRUE)

  # column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'MV_CF_LANDINGS' and owner='STOCKEFF';"
  colNames <- RODBC::sqlQuery(channel,sqlcolName,errors=TRUE,as.is=TRUE)

  return (list(data=query,sql=sqlStatement, colNames=colNames))
}


createString <- function(itemName,chosenItem,convertToCharacter,numChars) {

  if (is.numeric(chosenItem) && (convertToCharacter==TRUE)) { # nedd to convert numeric to character for sql
    str <- sprintf(paste0("%0",numChars,"d"),chosenItem)
    str <- paste0("'", str, "'", collapse=", ")
    itemStr <-  paste0(" (",itemName," in (",str,"))")
  } else if (is.numeric(chosenItem) && (convertToCharacter==FALSE)) {
    itemStr <-  paste0(" (",itemName," in (",toString(chosenItem),"))")
  } else { # not numeric
    if (tolower(chosenItem)=="all"){
      itemStr <-  NULL
    } else {
      stop(paste0("Not coded for yet -- createString:",itemName," with ",chosenItem))
    }

  }
  return(itemStr)
}


createTonnageString <- function(itemName,chosenItem){
  if (is.numeric(chosenItem)) { # tonnage class
    # search for individual tonnage class type or vector
    itemStr <- " ("
    numItems <- length(chosenItem)
    if (numItems > 1) { # if more than one ionnage class.
      for (it in 1:(numItems-1)) {
        tonnage <- chosenItem[it]
        itemStr <- paste0(itemStr,itemName," like \'",tonnage,"%\' or ")
      }
    } else {# append last one
    }
    itemStr <- paste0(itemStr,itemName," like \'",tail(chosenItem,1),"%\')")
  } else { #Fleet
    if (tolower(chosenItem) == "all") {
      itemStr <- NULL
    } else {
      stop("Not valid tonnage Argument. Either \"ALL\" or a vector of tonnage classes (see toncl1)")
    }
    # AND area IN (513,515,514) etc.
  }
  return(itemStr)
}
