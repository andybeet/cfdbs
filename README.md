# cfdbs

![gitleaks](https://github.com/NOAA-EDAB/cfdbs/workflows/gitleaks/badge.svg)


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


## Contact

| [andybeet](https://github.com/andybeet)        
| ----------------------------------------------------------------------------------------------- 
| [![](https://avatars1.githubusercontent.com/u/22455149?s=100&v=4)](https://github.com/andybeet) | 



#### Legal disclaimer

*This repository is a scientific product and is not official
communication of the National Oceanic and Atmospheric Administration, or
the United States Department of Commerce. All NOAA GitHub project code
is provided on an ‘as is’ basis and the user assumes responsibility for
its use. Any claims against the Department of Commerce or Department of
Commerce bureaus stemming from the use of this GitHub project will be
governed by all applicable Federal law. Any reference to specific
commercial products, processes, or services by service mark, trademark,
manufacturer, or otherwise, does not constitute or imply their
endorsement, recommendation or favoring by the Department of Commerce.
The Department of Commerce seal and logo, or the seal and logo of a DOC
bureau, shall not be used in any manner to imply endorsement of any
commercial product or activity by DOC or the United States Government.*



