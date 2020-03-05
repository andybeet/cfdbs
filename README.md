# cfdbs

A suite of tools to easily extract data from cfdbs and the landings table of ADIOS

To use this package successfully you will need:

1. Permissions to access the required server : a username and password.
2. Permissions to access ADIOS landings table (mv_cf_landings)
3. Oracle's instantClient installed

Benefits: 

1. Reduces the time required to extract data
2. Enables the user to focus on analysis and visualization

## Installation

```r 
remotes::install_github("andybeet/cfdbs",build_vignettes = TRUE)
```

Before using any of the functions a connection to the database will be required using the following:

```r 
channel <- dbutils::connect_to_database("server", "uid")
```


## Help

Explaination of package contents and usage can be found in the vignette:

``` r
browseVignettes("cfdbs")
```






