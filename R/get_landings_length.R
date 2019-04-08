#' Extract landings data by length from ADIOS! (help from CFDBS)
#'
#'Extract landings information by length (\code{len},\code{numlen},\code{spplndlb}) in cm/lbs from ADIOS! (mv_cf_len). This function requires no knowledge of sql.
#'For direct sql usage please see \code{\link{get_anything_sql}} function
#'
#'
#'@param channel an RODBC object (see \code{\link{connect_to_database}})
#'@param areas a numeric vector of statistical areas (area)
#'@param gears a numeric vector of gear types (negear2)
#'@param years a numeric vector containing the years to search over
#'@param species a numeric list of species (nespp3)
#'
#'@return A list is returned:
#'
#'   \code{data}      containing the result of the data pull ( year, month, day, qrt, negear, negear2, nespp3, nespp4, market_code, area, spplndlb, length, numlen, sex  )
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
#'@seealso \code{\link{connect_to_database}}, \code{\link{get_anything_sql}}
#'
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
#'

get_landings_length <- function(channel,area="all",gear="all",year=1994,species="all"){

  # create an SQL query to extract all relavent data from tables
  # this will require the user to enter statistical area, EPU, fleet characteristics, species etc.

  # list of strings to build where clause in sql statement
  whereVec <- list()

  whereVec[[1]] <-  createString(itemName="area",area,convertToCharacter=TRUE,numChars=3)
  whereVec[[2]] <-  createString(itemName="negear2",gear,convertToCharacter=TRUE,numChars=2)
  whereVec[[3]] <-  createString(itemName="nespp3",species,convertToCharacter=TRUE,numChars=3)
  whereVec[[4]] <-  createString(itemName="year",year,convertToCharacter=TRUE,numChars=4)
  

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
  sqlStatement <- "select year, month, day, qtr, negear, negear2, nespp3, nespp4, market_code, area, spplndlb, length, numlen, sex 
                from stockeff.mv_cf_len "

  sqlStatement <- paste(sqlStatement,whereStr)

  # call database
  query <- RODBC::sqlQuery(channel,sqlStatement,errors=TRUE,as.is=TRUE)

  # column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'MV_CF_LANDINGS' and owner='STOCKEFF';"
  colNames <- RODBC::sqlQuery(channel,sqlcolName,errors=TRUE,as.is=TRUE)

  return (list(data=query,sql=sqlStatement, colNames=colNames))
}



