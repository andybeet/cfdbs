% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_locations.R
\name{get_locations}
\alias{get_locations}
\title{Extract LOCATION information from CFDBS}
\usage{
get_locations(channel, sqlStatement = "select * from cfdbs.loc;")
}
\arguments{
\item{channel}{DBI Object. Inherited from \link[DBI]{DBIConnection-class}. This object is used to connect
to communicate with the database engine. (see \code{\link{connect_to_database}})}

\item{sqlStatement}{Character string. An sql statement (optional)}
}
\value{
A list is returned:

   \item{locations}{containing the result of the executed \code{sqlStatement} }

   \item{sql}{containing the \code{sqlStatement} itself}

   \item{colNames}{a vector of the table's column names}

If no \code{sqlStatement} is provided the default sql statement "\code{select * from cfdbs.loc}" is used
}
\description{
Extract a list of lat, long, ten minute square, etc from the NEFSC "loc" supporting table
}
\section{Reference}{

Use the data dictionary (\url{http://nova.nefsc.noaa.gov/datadict/}) for field name explanations
}

\examples{
\dontrun{
# extracts complete locations table based on default sql statement
channel <- connect_to_database(server="name_of_server",uid="individuals_username")
get_locations(channel)

# extracts subset of location information. Statistical area, and 10 minute square based on custom sql statement
channel <- connect_to_database(server="name_of_server",uid="individuals_username")
sqlStatement <- "select area TENMSQ from cfdbs.loc;"
get_locations(channel,sqlStatement)

# extracts 10 minute square info for an area on geaorges bank (511) based on custom sql statement
channel <- connect_to_database(server="name_of_server",uid="individuals_username")
sqlStatement <- "select area, tenmsq  from cfdbs.loc where area=511;"
get_locations(channel,sqlStatement)
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
\code{\link{get_landings}()},
\code{\link{get_ports}()},
\code{\link{get_species_itis}()},
\code{\link{get_species}()},
\code{\link{get_vessels}()}
}
\concept{get functions}
