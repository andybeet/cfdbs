#' Extract LOCATION information from CFDBS
#'
#'Extract a list of lat, long, ten minute square, etc from the NEFSC "loc" supporting table
#'
#'
#' @param channel DBI Object. Inherited from \link[DBI]{DBIConnection-class}. This object is used to connect
#' to communicate with the database engine. (see \code{\link{connect_to_database}})
#' @param sqlStatement Character string. An sql statement (optional)
#' 
#' 
#' @return A list is returned:
#'
#'    \item{locations}{containing the result of the executed \code{sqlStatement} }
#'
#'    \item{sql}{containing the \code{sqlStatement} itself}
#'
#'    \item{colNames}{a vector of the table's column names}
#'
#'If no \code{sqlStatement} is provided the default sql statement "\code{select * from cfdbs.loc}" is used
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
#' # extracts complete locations table based on default sql statement
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_locations(channel)
#'
#' # extracts subset of location information. Statistical area, and 10 minute square based on custom sql statement
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' sqlStatement <- "select area TENMSQ from cfdbs.loc;"
#' get_locations(channel,sqlStatement)
#'
#' # extracts 10 minute square info for an area on geaorges bank (511) based on custom sql statement
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' sqlStatement <- "select area, tenmsq  from cfdbs.loc where area=511;"
#' get_locations(channel,sqlStatement)
#'}
#'
#' @export
#'
#
get_locations <- function(channel,sqlStatement="select * from cfdbs.loc;"){

  query <- DBI::dbGetQuery(channel,sqlStatement)

  #data <- query[order(query$AREA),]

  #save(species,file="data/speciesDefinitions.RData")

  # get column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'LOC' and owner='CFDBS'"
  colNames <- DBI::dbGetQuery(channel,sqlcolName)

  return (list(data=dplyr::as_tibble(query),sql=sqlStatement, colNames=colNames))

}



