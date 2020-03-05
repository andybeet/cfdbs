#' Extract fishing GEAR types from CFDBS
#'
#'Extract a list of gear types in the NEFSC "GEAR" supporting table
#'
#'
#' @param channel DBI Object. Inherited from \link[DBI]{DBIConnection-class}. This object is used to connect
#' to communicate with the database engine. (see \code{\link{connect_to_database}})
#' @param gears specific gear code or set of codes. Either numeric or character vector. Defaults to "all" gears.
#' Numeric codes are converted to VARCHAR2(2 BYTE) when creating the sql statement. Character codes are short character strings referencing GEARNM field.
#'
#'
#' @return A list is returned:
#'
#'   \item{gears}{containing the result of the executed \code{sqlStatement}}
#'
#'   \item{sql}{containing the sql call}
#'
#'   \item{colNames}{a vector of the table's column names}
#'
#'If no \code{sqlStatement} is provided the default sql statement "\code{select * from cfdbs.gear}" is used
#'
#'@section Reference:
#'Use the data dictionary (\url{http://nova.nefsc.noaa.gov/datadict/}) for field name explanations

#' @seealso \code{\link{connect_to_database}}, , \code{\link{get_gears}}, \code{\link{get_species}}, \code{\link{get_areas}}, \code{\link{get_locations}}
#' , \code{\link{get_vessels}}, \code{\link{get_ports}}
#'
#' @examples
#' \dontrun{
#' # extracts gear data from cfdbs.gear table based on the default \code{sqlStatement}
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_gears(channel)
#'
#' # extracts info based on gear types (5,6) (numeric)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_gears(channel,gears=c(5,6))
#'
#' # extracts info based on gear types (5,6) (character)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_gears(channel,gears=c("05","06"))
#' 
#' # extracts info for "Seines"
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_gears(channel,"seines") or
#' 
#'}
#'
#' @export
#'
#
get_gears <- function(channel,gears="all") {

  #appends where
#  if (!is.null(where)) {
#    sqlStatement <- paste(sqlStatement,"where",where,";")
#  }

  sqlStatement <- dbutils::create_sql(gears,fieldName="negear2",fieldName2="gearnm",dataType="%02d",defaultSqlStatement="select * from cfdbs.gear")
  
  
  query <- DBI::dbGetQuery(channel,sqlStatement)

# get column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'GEAR' and owner='CFDBS';"
  colNames <- DBI::dbGetQuery(channel,sqlcolName)

  return (list(data=dplyr::as_tibble(query),sql=sqlStatement, colNames=colNames))

}


