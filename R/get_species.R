#' Extract SPECIES information from CFDBS
#'
#'Extract a list of speices names, code, market category, etc from the NEFSC cfspp table
#'
#'
#' @param channel an RODBC object (see \code{\link{connect_to_database}})
#' @param species a specific species code or set of codes. Either numeric or character vector. Defaults to "all" species.
#' Numeric codes are converted to VARCHAR2(3 BYTE) when creating the sql statement. Character codes are short character strings.
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
#' @seealso \code{\link{connect_to_database}}, \code{\link{get_gears}}, \code{\link{get_species}}, \code{\link{get_areas}}, \code{\link{get_locations}}
#' , \code{\link{get_vessels}}, \code{\link{get_ports}}, \code{\link{get_anything_sql}}
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
  sqlStatement <- create_sql_cfdbs(species,fieldName="nespp3",fieldName2="sppnm8",dataType="%03d",defaultSqlStatement="select * from cfdbs.cfspp")

  query <- RODBC::sqlQuery(channel,sqlStatement,errors=TRUE,as.is=TRUE)

  # get column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'CFSPP' and owner='CFDBS';"
  colNames <- t(RODBC::sqlQuery(channel,sqlcolName,errors=TRUE,as.is=TRUE))

  return (list(data=query,sql=sqlStatement, colNames=colNames))

}



