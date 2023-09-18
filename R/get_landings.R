#' Extract landings data from ADIOS! (help from CFDBS)
#'
#'Extract landings information (\code{trplndlb},\code{trplivlb},\code{spplndlb},\code{spplivlb}) in lbs from the databse ADIOS! This function requires no knowledge of sql.
#'NOTE: Eventually hope to pull \code{numlen}, and \code{len} also. This resides in a different table in ADIOS
#'For direct sql usage please see \code{\link{get_anything_sql}} function
#'
#'
#'@param channel DBI Object. Inherited from \link[DBI]{DBIConnection-class}. This object is used to connect
#' to communicate with the database engine. (see \code{\link{connect_to_database}})
#'@param areas Numeric vector. Statistical areas (area)
#'@param gears Numeric vector. Gear types (negear2)
#'@param years Numeric vector. Containing the years to search over
#'@param tonnage Numeric vector. Tonnage classes (toncl2) (1 - 8) where 1 = 10-19 tons, 2 = 20-29 tons etc
#'@param species Numeric vector. Species codes (nespp3 or species_itis)
#'@param gearCode Character string. Relates to the codes supplied in \code{gears}. Either "NEGEAR" or "NEGEAR2".
#'@param species_itis Boolean. Indicating if species values are nespp3 (FALSE) or species_itis (TRUE).Default = FALSE
#'
#'@return A list is returned:
#'
#'   \code{data}      containing the result of the data pull (year, month, day, negear, negear2, toncl2, nespp3, nespp4, species_itis, market_code, area, ntrips, mesh, df, da, spplndlb, spplivlb, trplndlb, trplivlb, GIS_LAT, GIS_LON  )
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
#'The ADIOS landings database (MV_CF_Landings) contains 35 million records. If you try to pull the entire database it is likely you will run out of memory.
#'
#'@family get functions
#'
#' @seealso \code{\link{connect_to_database}}
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

get_landings <- function(channel,area="all",gear="all",year=1994,tonnage="all",species="all",gearCode="NEGEAR2",species_itis=FALSE){

  # create an SQL query to extract all relavent data from tables
  # this will require the user to enter statistical area, EPU, fleet characteristics, species etc.

  # list of strings to build where clause in sql statement
  whereVec <- list()

  whereVec[[1]] <-  dbutils::createString(itemName="area",area,convertToCharacter=TRUE,numChars=3)
  if (tolower(gearCode) =="negear2") {
    whereVec[[2]] <-  dbutils::createString(itemName="negear2",gear,convertToCharacter=TRUE,numChars=2)
  } else if (tolower(gearCode) =="negear") {
    whereVec[[2]] <-  dbutils::createString(itemName="negear",gear,convertToCharacter=TRUE,numChars=3)
  } else {
    stop(message(paste0("Gear codes must match NEGEAR or NEGEAR2 specs")))
  }
  if (species_itis == FALSE) {
    whereVec[[3]] <-  dbutils::createString(itemName="nespp3",species,convertToCharacter=TRUE,numChars=3)
  } else {
    whereVec[[3]] <-  dbutils::createString(itemName="species_itis",species,convertToCharacter=TRUE,numChars=6)
  }
  whereVec[[4]] <-  dbutils::createString(itemName="year",year,convertToCharacter=TRUE,numChars=4)
  whereVec[[5]] <-  dbutils::createTonnageString(itemName="toncl2",tonnage)

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
  sqlStatement <- "select year, month, day, negear, negear2, toncl2, nespp3, nespp4, species_itis, market_code, area, ntrips, mesh,df, da , spplndlb,spplivlb, trplndlb,trplivlb,GIS_LAT,GIS_LON  
                    from stockeff.mv_cf_landings"
  
  sqlStatement <- paste(sqlStatement,whereStr)

  # call database
  query <- DBI::dbGetQuery(channel,sqlStatement)

  # column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'MV_CF_LANDINGS' and owner='STOCKEFF'"
  colNames <- DBI::dbGetQuery(channel,sqlcolName)

  return (list(data=dplyr::as_tibble(query),sql=sqlStatement, colNames=colNames))
}


