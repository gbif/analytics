# "enums" (constant factors after interp is done). Unknown is expected to be first
borFactors <- c("Unknown", "Observation", "Specimen", "Other")
kingdomFactors <- c("Unknown", "Animalia", "Plantae", "Other")
rankFactors <- c("Unknown", "Higher taxon", "Genus", "Species", "Infraspecies")
geospatialFactors <- c("Unknown", "Georeferenced", "CountryOnly")
temporalFactors <- c("Unknown", "YearMonthDay", "YearMonth", "Year")

# snapshots used in the temporal facets (e.g. collection year)
# December/January snapshots:
#
# yearEnds <- c("20071219" "20081217" "20091216" "20101117" "20120118" "20121211" "20131220" "20150119" "20160104" "20161227" "20171222" "20190101" "20200101" "20210101" "20220101" "20230101" "20240101" "20241001" "20250101" "20250401")
#               ..........                                             ..........                                             ..........                                                            ..........
# Split into four
temporalFacetSnapshots <- c("2007-12-19", "2015-01-19", "2021-01-01", "2025-04-01")

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
  print(paste("Writing web plot: ", file))
  ggsave(filename=file, plot=plot, width=8, height=6);
}

saveSvg <- function(plot, file) {
  print(paste("Writing svg plot: ", file))
  ggsave(filename=file, plot=plot, device='svg', width=8, height=6)
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

# inserts a 0 count for every combination of missing factors at every timestamp
populate_factors <- function(fileData, columnsToCheck) {
  finalData <- fileData
  doBor <- 'basisOfRecord' %in% columnsToCheck
  doRank <- 'rank' %in% columnsToCheck
  doGeo <- 'georeferenced' %in% columnsToCheck
  doTemporal <- 'temporal' %in% columnsToCheck
  doKingdom <- 'kingdom' %in% columnsToCheck

  for (targetSnapshot in unique(fileData$snapshot)) {
    snapshotData <- fileData[ which(fileData$snapshot==targetSnapshot), ]

    # check if a "count" column needs adding in
    if ("occurrenceCount" %in% colnames(fileData)) {
      facetsData <- data.frame(snapshot=as.Date(targetSnapshot, origin = "1970-01-01"), occurrenceCount=0)
    } else if ("speciesCount" %in% colnames(fileData)) {
      facetsData <- data.frame(snapshot=as.Date(targetSnapshot, origin = "1970-01-01"), speciesCount=0)
    } else {
      # don't think this path is ever used
      facetsData <- data.frame(snapshot=as.Date(targetSnapshot, origin = "1970-01-01"))
    }

    if (doBor) {
      missingBorFactors <- setdiff(borFactors, unique(snapshotData$basisOfRecord))
      bor <- if (length(missingBorFactors) > 0) missingBorFactors else borFactors[1]
      facetsData <- combine_factors(facetsData, bor, "basisOfRecord")
    }
    if (doRank) {
      missingRankFactors <- setdiff(rankFactors, unique(snapshotData$rank))
      rank <- if (length(missingRankFactors) > 0) missingRankFactors else rankFactors[1]
      facetsData <- combine_factors(facetsData, rank, "rank")
    }
    if (doGeo) {
      missingGeoFactors <- setdiff(geospatialFactors, unique(snapshotData$geospatial))
      geo <- if (length(missingGeoFactors) > 0) missingGeoFactors else geospatialFactors[1]
      facetsData <- combine_factors(facetsData, rank, "geospatial")
    }
    if (doTemporal) {
      missingTemporalFactors <- setdiff(temporalFactors, unique(snapshotData$temporal))
      temporal <- if (length(missingTemporalFactors) > 0) missingTemporalFactors else temporalFactors[1]
      facetsData <- combine_factors(facetsData, temporal, "temporal")
    }
    if (doKingdom) {
      missingKingdomFactors <- setdiff(kingdomFactors, unique(snapshotData$kingdom))
      kingdom <- if (length(missingKingdomFactors) > 0) missingKingdomFactors else kingdomFactors[1]
      facetsData <- combine_factors(facetsData, kingdom, "kingdom")
    }

    finalData <- rbind(facetsData, finalData)
  }

  return(finalData)
}

combine_factors <- function(facetsData, missingFactors, colName) {
  newFacets <- facetsData
  if (length(missingFactors) > 1) {
    # in order for the bind to duplicate our new column enough times to cover all combinations we have to start with
    # enough rows (multiplying existing rows by number of added factors)
    newFacets <- facetsData[rep(1:nrow(facetsData),each=length(missingFactors)),]
  }
  newFacets <- cbind(newFacets, missingFactors)
  names(newFacets)[ncol(newFacets)] <- colName
  return(newFacets)
}
