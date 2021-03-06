% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_landings.R
\name{get_landings}
\alias{get_landings}
\title{Extract landings data from ADIOS! (help from CFDBS)}
\usage{
get_landings(
  channel,
  area = "all",
  gear = "all",
  year = 1994,
  tonnage = "all",
  species = "all",
  gearCode = "NEGEAR2",
  species_itis = FALSE
)
}
\arguments{
\item{channel}{DBI Object. Inherited from \link[DBI]{DBIConnection-class}. This object is used to connect
to communicate with the database engine. (see \code{\link{connect_to_database}})}

\item{tonnage}{Numeric vector. Tonnage classes (toncl2) (1 - 8) where 1 = 10-19 tons, 2 = 20-29 tons etc}

\item{species}{Numeric vector. Species codes (nespp3 or species_itis)}

\item{gearCode}{Character string. Relates to the codes supplied in \code{gears}. Either "NEGEAR" or "NEGEAR2".}

\item{species_itis}{Boolean. Indicating if species values are nespp3 (FALSE) or species_itis (TRUE).Default = FALSE}

\item{areas}{Numeric vector. Statistical areas (area)}

\item{gears}{Numeric vector. Gear types (negear2)}

\item{years}{Numeric vector. Containing the years to search over}
}
\value{
A list is returned:

  \code{data}      containing the result of the data pull (year, month, day, negear, negear2, toncl2, nespp3, nespp4, species_itis, market_code, area, ntrips, mesh, df, da, spplndlb, spplivlb, trplndlb, trplivlb, GIS_LAT, GIS_LON  )

  \code{sql}  the resulting sql statement based on user input

  \code{colNames} a vector of the table's column names
}
\description{
Extract landings information (\code{trplndlb},\code{trplivlb},\code{spplndlb},\code{spplivlb}) in lbs from the databse ADIOS! This function requires no knowledge of sql.
NOTE: Eventually hope to pull \code{numlen}, and \code{len} also. This resides in a different table in ADIOS
For direct sql usage please see \code{\link{get_anything_sql}} function
}
\section{Reference}{

Use the data dictionary (\url{http://nova.nefsc.noaa.gov/datadict/}) for field name explanations
}

\section{Warning}{

You will need to obtain read only privilages to access ADIOS! 
The ADIOS landings database (MV_CF_Landings) contains 35 million records. If you try to pull the entire database it is likely you will run out of memory.
}

\examples{
\dontrun{

# extracts landings for cod (081) in area 500 for ton class >=10 by <20 using  gear types (1,2,10)
channel <- connect_to_database(server="name_of_server",uid="individuals_username")

get_landings(channel,area=c(500,600),gear=c(1,2,10),year=c(1999),tonnage=c(1),species=81)
}

}
\seealso{
\code{\link{connect_to_database}}

Other get functions: 
\code{\link{get_age_length}()},
\code{\link{get_anything_sql}()},
\code{\link{get_areas}()},
\code{\link{get_gears}()},
\code{\link{get_landings_length}()},
\code{\link{get_landings_palmer}()},
\code{\link{get_locations}()},
\code{\link{get_ports}()},
\code{\link{get_species_itis}()},
\code{\link{get_species}()},
\code{\link{get_vessels}()}
}
\concept{get functions}
