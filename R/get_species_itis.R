#' Extract SPECIES information from CFDBS (SPECIES_ITIS_NE, table)
#'
#'Extract a list of speices names, code, market category, etc from the NEFSC SPECIES_ITIS_NE table
#'
#'
#' @param channel an RODBC object (see \code{\link{connect_to_database}})
#' @param species a specific species code or set of codes. Either numeric or character vector. Defaults to "all" species.
#' Numeric codes (SPECIES_ITIS) are converted to VARCHAR2(33) when creating the sql statement. Character codes are short character strings.
#' @param nameType either "common_name" (default) or "scientific_name". Determins which type of name to search under
#'
#' @return A list is returned:
#'
#'   \item{species}{containing the result of the executed \code{$sql} statement}
#'
#'   \item{sql}{containing the sql call}
#'
#'   \item{colNames}{a vector of the table's column names}
#'
#'The default sql statement "\code{select * from cfdbs.SPECIES_ITIS_NE}" is used
#'
#'@section Reference:
#'Use the data dictionary (\url{http://nova.nefsc.noaa.gov/datadict/}) for field name explanations. 
#'
#' @seealso \code{\link{connect_to_database}}, \code{\link{get_gears}}, \code{\link{get_species}}, \code{\link{get_areas}}, \code{\link{get_locations}}
#' , \code{\link{get_vessels}}, \code{\link{get_ports}}, \code{\link{get_anything_sql}}
#'
#' @examples
#' \dontrun{
#' # extracts complete species table based on custom sql statement
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_species_itis(channel)
#'
#' # extracts info for cod (164712) 
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_species_itis(channel,species=164712)
#' 
#' # extracts info for cod ("COD") 
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_species_itis(channel,"cod") or
#' get_species_itis(channel,"co") or (note also return cockles, calico scallop etc.) 
#' get_species_itis(channel,"COD")
#' 
#'
#' # extracts info for cod (164712)  and bluefish (168559)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' sqlStatement <- "select * from cfdbs.species_itis_ne"
#' get_species_itis(channel,species= c("164712","168559"))
#'}
#'
#' @export
#'
#

get_species_itis <- function(channel,species="all",nameType="common_name"){
  
  # nameType = common_name or scientific_name

  # creates the sql based on user input
  sqlStatement <- dbutils::create_sql(species,fieldName="species_itis",fieldName2=nameType,dataType="%06d",defaultSqlStatement="select * from cfdbs.species_itis_ne")

  query <- DBI::dbGetQuery(channel,sqlStatement)

  # get column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'SPECIES_ITIS_NE' and owner='CFDBS';"
  colNames <- t(DBI::dbGetQuery(channel,sqlcolName))

  return (list(data=dplyr::as_tibble(query),sql=sqlStatement, colNames=colNames))

}



