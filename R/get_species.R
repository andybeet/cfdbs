#' Extract SPECIES information from CFDBS
#'
#'Extract a list of speices names, code, market category, etc from the NEFSC cfspp table
#'
#'
#' @param channel DBI Object. Inherited from \link[DBI]{DBIConnection-class}. This object is used to connect
#' to communicate with the database engine. (see \code{\link{connect_to_database}})
#' @param species a specific species code or set of codes. Either numeric or character vector. (NESPP3 codes)
#' Numeric codes are converted to VARCHAR2(3 BYTE) when creating the sql statement.
#' A Species common name can also be supplied. The character string is used to pull from SPPNM field. Defaults to "all" species.
#'
#' @return A list is returned:
#'
#'   \item{species}{containing the result of the executed \code{$sql} statement}
#'
#'   \item{sql}{containing the sql call}
#'
#'   \item{colNames}{a vector of the table's column names}
#'
#'The default sql statement "\code{select * from cfdbs.cfspp}" is used
#'
#'@section Reference:
#'Use the data dictionary (\url{http://nova.nefsc.noaa.gov/datadict/}) for field name explanations. 
#'Note: species codes (nespp3) are stored in the database as VARCHAR2(3 BYTE) 
#'
#'@family get functions
#'
#' @seealso \code{\link{connect_to_database}}
#' 
#' @examples
#' \dontrun{
#' # extracts complete species table based on custom sql statement
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_species(channel)
#'
#' # extracts info for cod (081) 
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_species(channel,species=81)
#' 
#' # extracts info for cod ("COD") 
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_species(channel,"cod") or
#' get_species(channel,"co") or
#' get_species(channel,"COD")
#' 
#'
#' # extracts info for cod (081)  and bluefish (023)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' sqlStatement <- "select * from cfdbs.cfspp"
#' get_species(channel,species= c("081","023"))
#'}
#'
#' @export
#'
#

get_species <- function(channel,species="all"){

  # creates the sql based on user input
  sqlStatement <- dbutils::create_sql(species,fieldName="nespp3",fieldName2="sppnm",dataType="%03d",defaultSqlStatement="select * from cfdbs.cfspp")

  query <- DBI::dbGetQuery(channel,sqlStatement)

  # get column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'CFSPP' and owner='CFDBS'"
  colNames <- t(DBI::dbGetQuery(channel,sqlcolName))

  return (list(data=dplyr::as_tibble(query),sql=sqlStatement, colNames=colNames))

}



