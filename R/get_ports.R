#' Extract PORT location information from CFDBS
#'
#'Extract a list of port names, and location info for vessel landings from the NEFSC "Port" supporting table
#'
#'
#' @param channel DBI Object. Inherited from \link[DBI]{DBIConnection-class}. This object is used to connect
#' to communicate with the database engine. (see \code{\link{connect_to_database}})
#' @param ports a specific port code or set of codes. Either numeric or character vector. Defaults to "all" ports.
#' Numeric codes are converted to VARCHAR2(6 BYTE) when creating the sql statement. Character codes are short character strings referencing PORTNM field.
#'
#' @return A list is returned:
#'
#'   \item{species}{containing the result of the executed \code{sqlStatement}}
#'
#'    \item{sql}{containing the sql call}
#'
#'   \item{colNames}{a vector of the table's column names}
#'
#'If no \code{sqlStatement} is provided the default sql statement "\code{select * from cfdbs.port}" is used
#'
#'@section Reference:
#'Use the data dictionary (\url{http://nova.nefsc.noaa.gov/datadict/}) for field name explanations
#'
#'@family get functions
#'
#' @seealso \code{\link{connect_to_database}}
#' 
#' @examples
#' \dontrun{
#' # extracts complete port table based on default sql statement
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_ports(channel)
#'
#' # extracts port details based on ports 224309 , 224409 (numeric)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_ports(channel,ports = c(224309,224409))
#'
#' # extracts port details based on ports 224309 , 224409 (character)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_ports(channel,ports = c("224309","224409"))
#' 
#' # extracts port details based on port name (character)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_ports(channel,ports = "Fairfield") or 
#' get_ports(channel,ports = "Fair")
#' 
#'}
#'
#' @export
#'
#
get_ports <- function(channel,ports="all"){

  # creates the sql based on user input
  sqlStatement <- dbutils::create_sql(ports,fieldName="port",fieldName2="portnm",dataType="%06d",defaultSqlStatement="select * from cfdbs.port")

  query <- DBI::dbGetQuery(channel,sqlStatement)

  #data <- query[order(query$PORTNM),]

  #save(species,file="data/speciesDefinitions.RData")
  # get column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'PORT' and owner='CFDBS'"
  colNames <- t(DBI::dbGetQuery(channel,sqlcolName))

  return (list(data=dplyr::as_tibble(query),sql=sqlStatement, colNames=colNames))

}



