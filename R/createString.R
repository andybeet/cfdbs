#' Utility function (Internal, not exported) to convert argument to strings
#' 
#' inputs to get_ functions are required as strings when passed as a sql statement
#' This function converts numeric inputs to character strings
#'
#' @param itemName Character string. Variable name as it exists in the data base
#' @param chosenItem User input value of variable listed in itemName
#' @param convertTocharacter Boolean. Should we convert the \code{chosenItem} to a character string (This depends on how the variable is declared in the database)
#' @param numchars Numeric scalar. Number of characters to format the numeric \code{chosenItem} as.
#' 
#' @return A charachter string
#' 
#' @examples 
#' \dontrun{
#' createString(itemName="area",area=503,convertToCharacter=TRUE,numChars=3)
#' createString(itemName="species_itis",species,convertToCharacter=TRUE,numChars=6)
#' 
#' }
#'



createString <- function(itemName,chosenItem,convertToCharacter,numChars) {
  
  if (is.numeric(chosenItem) && (convertToCharacter==TRUE)) { # need to convert numeric to character for sql
    str <- sprintf(paste0("%0",numChars,"d"),chosenItem)
    str <- paste0("'", str, "'", collapse=", ")
    itemStr <-  paste0(" (",itemName," in (",str,"))")
  } else if (is.numeric(chosenItem) && (convertToCharacter==FALSE)) {
    itemStr <-  paste0(" (",itemName," in (",toString(chosenItem),"))")
  } else { # not numeric
    if (tolower(chosenItem)=="all"){
      itemStr <-  NULL
    } else {
      stop(paste0("Not coded for yet -- createString:",itemName," with ",chosenItem))
    }
    
  }
  return(itemStr)
}
