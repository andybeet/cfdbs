# given EPU we filter by tonage class

read_toncl1_rule <- function(){
  data <- read.csv("data/Fleets_bytoncl1.csv",header=TRUE, stringsAsFactors=FALSE,row.names = 1)
}