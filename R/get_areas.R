#' Extract AREA information from CFDBS
#'
#'Extract a list of statistical areas, region, NAFO codes, etc from the NEFSC "Area" supporting table
#'
#'
#' @param channel an RODBC object (see \code{\link{connect_to_database}})
#' @param areas a specific area code or set of codes. Either numeric or character vector. Defaults to "all" areas
#' Numeric codes are converted to VARCHAR2(3 BYTE) when creating the sql statement. Character codes are short character strings to reference the AREANM field.
#'
#' @return A list is returned:
#'
#'    \item{areas}{containing the result of the executed \code{sqlStatement}}
#'
#'    \item{sql}{containing the sql call}
#'
#'    \item{colNames}{ a vector of the table's column names}
#'
#'The default sql statement "\code{select * from cfdbs.area}" is used
#'
#'@section Reference:
#'Use the data dictionary (\url{http://nova.nefsc.noaa.gov/datadict/}) for field name explanations
#'
#' @seealso \code{\link{connect_to_database}}, \code{\link{get_gears}}, \code{\link{get_species}}, \code{\link{get_areas}}, \code{\link{get_locations}}
#' , \code{\link{get_vessels}}, \code{\link{get_ports}}
#'
#' @examples
#' \dontrun{
#' # extracts complete area table based on default sql statement
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_areas(channel)
#'
#' # extracts a subset of area data based on selected areas 100,500 (numeric)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_areas(channel,areas=c(100,500))
#'
#' # extracts a subset of area data based on selected areas 100,500 (character)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_areas(channel,areas=c("100","500"))
#' 
#' # extracts a subset of area data based on areanm's containing "GG" (Androscoggin River etc)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_areas(channel,"GG")

#'
#'}
#'
#' @export
#'
#
get_areas <- function(channel,areas="all"){


  sqlStatement <- dbutils::create_sql(areas,fieldName="area",fieldName2="areanm",dataType="%03d",defaultSqlStatement="select * from cfdbs.area")
  
  query <- DBI::dbGetQuery(channel,sqlStatement)

  # get column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'AREA' and owner='CFDBS';"
  colNames <- t(DBI::dbGetQuery(channel,sqlcolName))

  return (list(data=query,sql=sqlStatement, colNames=colNames))

}



