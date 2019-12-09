#' Extract Length at Age data CFDBS
#'
#'Extract a list of length and ages for speices sampled in Commercial fisheries data.
#'This data is extracted from ADIOS (MV_CF_AGE)
#'
#' @param channel an Object inherited from \link[DBI]{DBIConnection-class}. This object is used to connect
#' to communicate with the database engine. (see \code{\link{connect_to_database}})
#' @param species a specific species code or set of codes. Either numeric or character vector. Defaults to "all" species.
#' Numeric codes are converted to VARCHAR2(3 BYTE) when creating the sql statement. Character codes are short character strings.
#' @param sex character vector. Default = "all". options "M" (male), "F" (female), "U" (unsexed)
#'
#' @return A list is returned:
#'
#'   \item{data}{containing the result of the executed \code{$sql} statement}
#'
#'   \item{sql}{containing the sql call}
#'
#'   \item{colNames}{a vector of the table's column names}
#'
#'The default sql statement "\code{select * from stockeff.mv_cf_age}" is used
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
#' # extracts all length and age data for all species defined as male or female (unsexed not included)
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_length_age(channel,sex=c("M","F"))
#'
#' # extracts info for cod (081) 
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_length_age(channel,species=81)
#' 
#' # extracts info for cod ("COD") 
#' channel <- connect_to_database(server="name_of_server",uid="individuals_username")
#' get_length_age(channel,"cod") or
#' get_length_age(channel,"co") or
#' get_length_age(channel,"COD")
#' 
#'}
#'
#' @export


get_age_length <- function(channel, year=1994, species="all", species_itis=FALSE, sex="all"){

  # create an SQL query to extract all relavent data from tables
  # list of strings to build where clause in sql statement
  whereVec <- list()

  if (species_itis == FALSE) {
    whereVec[[1]] <-  dbutils::createString(itemName="nespp3",species,convertToCharacter=TRUE,numChars=3)
  } else {
    whereVec[[2]] <-  dbutils::createString(itemName="species_itis",species,convertToCharacter=TRUE,numChars=6)
  }
  whereVec[[3]] <-  dbutils::createString(itemName="year",year,convertToCharacter=TRUE,numChars=4)
  
  # sex conversion
  if (tolower(sex) == "all") {
    sex <- c(0,1,2)
  } else if (!is.numeric(sex)) {
    sex <- gsub("M",1,sex)
    sex <- gsub("F",2,sex)
    sex <- as.numeric(gsub("U",0,sex))
  }

  whereVec[[4]] <-  paste("sex in (",toString(sex),")")

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
  sqlStatement <- "select year, nespp3, nespp4, species_itis, sex, age, length  
                    from stockeff.mv_cf_age"

  sqlStatement <- paste(sqlStatement,whereStr)

  # call database
  query <- DBI::dbGetQuery(channel,sqlStatement)

  # column names
  sqlcolName <- "select COLUMN_NAME from ALL_TAB_COLUMNS where TABLE_NAME = 'MV_CF_LANDINGS' and owner='STOCKEFF';"
  colNames <- DBI::dbGetQuery(channel,sqlcolName)

  return (list(data=dplyr::as_tibble(query),sql=sqlStatement, colNames=colNames))
}



