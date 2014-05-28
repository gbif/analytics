# the snapshots that are closest to year ends
annualSnapshots <- c("2007-12-19", "2008-12-17", "2009-12-16", "2010-11-17", "2012-01-18", "2012-12-11", "2013-09-10", "2014-05-09")

# snapshots used in the temrporal facets (e.g. collection year)
temporalFacetSnapshots <- c("2007-12-19", "2010-11-17", "2013-09-10", "2014-05-09")

# minimum year to plot of year range charts
minPlotYear <- 1950

# used to reduce record counts to counts per million, thousand etc
mill_formatter <- function(x) {
  lab <- x / 1000000
}  
kilo_formatter <- function(x) {
  lab <- x / 1000
}  

savePng <- function(plot, file) {
  ggsave(filename=file, plot=plot, width=8, height=6);  
}


# rewrite kingdom
interpKingdom <- function(id) {
  if (id==0) {
    return("Unknown")
  } else if (id==1) {
    return("Animalia")
  } else if (id==6) {
    return("Plantae")
  }
  return("Other")
}

# rewrite kingdom
interpRank <- function(rank) {
  if ("Infraspecies"== rank) {
    return("Infraspecies")
  } else if ("Species"== rank) {
    return("Species")
  } else if ("Genus"== rank) {
    return("Genus")
  }
  return("Higher taxon")
}

interpBasisOfRecord <- function(bor) {
  if (bor %in% c("MACHINE_OBSERVATION", "OBSERVATION", "HUMAN_OBSERVATION")) {
    return("Observation")
  } else if (bor %in% c("PRESERVED_SPECIMEN")) {
    return("Specimen")
  } else if (bor %in% c("UNKNOWN")) {
    return("Unknown")
  } else {
    return("Other")  
  }    
}