#' Extract VESSEL information from CFDBS
#'
#'Extract a list of vessell ID's, tonnage, crew size, home port, etc from the NEFSC "Mstrvess" supporting table
#'
#'
#' @param channel DBI Object. Inherited from \link[DBI]{DBIConnection-class}. This object is used to connect
#' to communicate with the database engine. (see \code{\link{connect_to_database}})
#' @param sqlStatement an sql statement (optional)
#' @param where text string appending where clause to sql
#'
#' @return A list is returned:
#'
#'   \item{vessels}{containing the result of the executed \code{sqlStatement} }
#'
#'   \item{sql}{containing the \code{sqlStatement} itself}
#'
#'  \item{colNames}{a vector of the table's column names}
#'
#'If no \code{sqlStatement} is provided the default sql statement "\code{select * from cfdbs.mstrvess}" is used
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
#' # extracts complete vessel table based on custom sql statement
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_vessels(channel)
#'
#' # extracts vessel ID, crew size, and home port on custom sql statement
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' sqlStatement <- "select vessel, crew, homeport from cfdbs.mstrvess;"
#' get_vessels(channel,sqlStatement)
#'
#' # extracts all vessel info for vessels lengths < 50ft based on custom sql statement
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' sqlStatement <- "select * from cfdbs.mstrvess where vesslen <29;"
#' get_vessels(channel,sqlStatement)
#'}
#'
#' @export
#'
#
get_vessels <- function(channel,sqlStatement="select * from cfdbs.mstrvess",where=NULL){

  #appends where
  if (!is.null(where)) {
    sqlStatement <- paste(sqlStatement,"where",where,";")
  }

  query <- DBI::dbGetQuery(channel,sqlStatement)

  #data <- query[order(query$VESSEL),]

  #save(species,file="data/speciesDefinitions.RData")

  # get column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'MSTRVESS' and owner='CFDBS'"
  colNames <- DBI::dbGetQuery(channel,sqlcolName)

  return (list(data=dplyr::as_tibble(query),sql=sqlStatement, colNames=colNames))

}



