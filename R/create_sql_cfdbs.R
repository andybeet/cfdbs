# called by all functions to formal the call to the cfdbs database
#
# seee get_species, get_gears etc

create_sql_cfdbs <- function(dataName,fieldName,fieldName2,dataType,defaultSqlStatement) {
  
  sqlStatement <- defaultSqlStatement
  
  if (is.numeric(dataName)) { # convert to string as where clause
    str <- sprintf(dataType,dataName)
    str <- paste0("'", str, "'", collapse=", ")
    where <-  paste0(" (",fieldName," in (",str,"))")
    sqlStatement <- paste(sqlStatement,"where",where,";")
  } else if (length(dataName) > 1){ # vector of character ids
    str <- paste0("'", dataName, "'", collapse=", ")
    where <-  paste0(" (",fieldName," in (",str,"))")
    sqlStatement <- paste(sqlStatement,"where",where,";")
  } else if (dataName == "all") {
    # we use default sqlStament
  } else if (suppressWarnings(is.na(as.numeric(dataName)))) {# species name
    where <-  paste0(fieldName2," like ","'%",toupper(dataName),"%'")
    sqlStatement <- paste(sqlStatement,"where",where,";")
  } else { # single character species id
    str <- paste0("'", dataName, "'", collapse=", ")
    where <-  paste0(" (",fieldName," in (",str,"))")
    sqlStatement <- paste(sqlStatement,"where",where,";")
  }
  
  return(sqlStatement)
  
}
