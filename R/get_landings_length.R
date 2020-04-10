#' Extract landings data by length from ADIOS! (help from CFDBS)
#'
#'Extract landings information by length (\code{len},\code{numlen},\code{spplndlb}) in cm/lbs from ADIOS! (mv_cf_len). This function requires no knowledge of sql.
#'For direct sql usage please see \code{\link{get_anything_sql}} function
#'
#'
#'@param channel DBI Object. Inherited from \link[DBI]{DBIConnection-class}. This object is used to connect
#' to communicate with the database engine. (see \code{\link{connect_to_database}})
#'@param areas Numeric vector. Statistical areas (area)
#'@param gears Numeric vector. Gear types (negear2)
#'@param years Numeric vector. containing the years to search over
#'@param species Numeric vector. Species codes (nespp3 or species_itis)
#'@param species_itis Boolean. Indicating if species values are nespp3 (FALSE) or species_itis (TRUE).Default = FALSE
#'
#'@return A list is returned:
#'
#'   \code{data}      containing the result of the data pull ( year, month, day, permit, qtr, negear, negear2, nespp3, nespp4, species_itis, market_code, area, spplndlb, length, numlen, numsamp, sex  )
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
#'The ADIOS landings by length database (MV_CF_LEN) contains 1.3 million records. If you try to pull the entire database you may suffer from memory issues.
#'
#'@family get functions
#'
#' @seealso \code{\link{connect_to_database}}
#' 
#'@examples
#'\dontrun{
#'
#' # extracts landings by length for cod (081) in area 500 using  gear types (1,2,10)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#'
#' get_landings_length(channel,area=c(500,600),gear=c(1,2,10),year=c(1999),species=81)
#'}
#'
#'@export


get_landings_length <- function(channel,area="all",gear="all",year=1994,species="all",species_itis=FALSE){

  # create an SQL query to extract all relavent data from tables
  # this will require the user to enter statistical area, EPU, fleet characteristics, species etc.

  # list of strings to build where clause in sql statement
  whereVec <- list()

  whereVec[[1]] <-  dbutils::createString(itemName="area",area,convertToCharacter=TRUE,numChars=3)
  whereVec[[2]] <-  dbutils::createString(itemName="negear2",gear,convertToCharacter=TRUE,numChars=2)
  if (species_itis == FALSE) {
    whereVec[[3]] <-  dbutils::createString(itemName="nespp3",species,convertToCharacter=TRUE,numChars=3)
  } else {
    whereVec[[3]] <-  dbutils::createString(itemName="species_itis",species,convertToCharacter=TRUE,numChars=6)
  }
  whereVec[[4]] <- dbutils::createString(itemName="year",year,convertToCharacter=TRUE,numChars=4)
  

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
  sqlStatement <- "select year, month, day, permit, qtr, negear, negear2, nespp3, nespp4, species_itis, market_code, area, spplndlb, length, numlen, numsamp, sex 
                from stockeff.mv_cf_len "

  sqlStatement <- paste(sqlStatement,whereStr)

  # call database
  query <- DBI::dbGetQuery(channel,sqlStatement)

  # column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'MV_CF_LANDINGS' and owner='STOCKEFF';"
  colNames <- DBI::dbGetQuery(channel,sqlcolName)

  return (list(data=dplyr::as_tibble(query),sql=sqlStatement, colNames=colNames))
}




