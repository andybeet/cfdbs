#' Extract anything from ADIOS! or CFDBS
#'
#'Extract any information from any database. This function is for people who know sql and understand the database well enough
#'to write their own sql statements. For all others, please see the \code{\link{get_landings}} and other similar functions
#'
#'
#' @param channel an RODBC object (see \code{\link{connect_to_database}})
#' @param sqlStatement an sql statement
#' @return A list is returned:
#'
#'  - \code{data} containing the result of the executed \code{sqlStatement} and
#'
#'  - \code{sql} containing the \code{sqlStatement} itself
#'
#'  - \code{colNames} a vector of the table's column names
#'
#'
#' There is no default sql statement.
#'
#'@section Warning:
#'You will need to obtain read only privilages to access any of the databases
#'Some of the databases contains many million records. If you try to pull the entire database it is likely you will run out of memory.
#'
#'@section Reference:
#'Use the data dictionary (\url{http://nova.nefsc.noaa.gov/datadict/}) for field name explanations
#'
#' @seealso \code{\link{connect_to_database}}, \code{\link{get_landings}}
#'
#' @examples
#' \dontrun{
#'
#' # extracts landings for cod (081) in area 500 for ton class >=10 by <20 using  gear types (1,2,10)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#'
#' sqlStatement <- "select year, month, nespp3, negear2, toncl2, trplndlb, area  from stockeff.mv_cf_landings
#'  where  (area in (500,600))  and (negear2 in (1,2,10)) and (nespp3 in 81) and (year in ('1999')) and (toncl2 like '1%');"
#'
#' get_anything_sql(channel,sqlStatement)
#'}
#'
#' @export

get_anything_sql <- function(channel,sqlStatement) {

  if (grepl("\\*",sqlStatement)) {
    warning ("Can not use wild card in sql statement - Your computer memory couldn't handle it!!! ")
    #query <- NULL
    query <- RODBC::sqlQuery(channel,sqlStatement,errors=TRUE,as.is=TRUE)

  } else {
    query <- RODBC::sqlQuery(channel,sqlStatement,errors=TRUE,as.is=TRUE)
  }

  # get column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'MV_CF_LANDINGS' and owner='STOCKEFF';"
  colNames <- RODBC::sqlQuery(channel,sqlcolName,errors=TRUE,as.is=TRUE)

  return (list(data=query, sql = sqlStatement,colNames=colNames))

}


