source("R/country-reports/pg1_kingdom_matrix.R")
source("R/country-reports/pg1_pub_research.R")
source("R/country-reports/pg1_pub_blob.R")
source("R/country-reports/pg2_traffic_table1_top5_cities.R")
source("R/country-reports/pg2_traffic_table2_world_vs_national.R")
source("R/country-reports/pg2_traffic_fig3_sessions_by_week.R")
source("R/country-reports/pg3_recent_publications.R")
source("R/country-reports/pg3_download_blob.R")
source("R/country-reports/pg3_fig4_country_downloads_per_month.R")
source("R/country-reports/pg4_taxon_matrix.R")
source("R/html-json/utils.R")

#########
# Generates multiple csv files to be used by InDesign for doing a "Data Merge" of the generated pdf figures into Country Reports. This file is specific to
# OS X (Apple) systems because of how InDesign reads file paths. Note that the macHdName has to be updated to match the (Apple) computer on which this is run.
#
# Figure  PDF
# 2       publishedby/occ_kingdom.pdf
# 3       countryReports/web_traffic_sessions_by_week.pdf
# 4       countryReports/downloaded_records_by_month.pdf
# 5       about/occ_kingdom.pdf
# 6       about/spe_kingdom.pdf
# 7       about/occ_complete_kingdom_specimen.pdf
# 8       about/occ_complete_kingdom_observation.pdf
# 9       about/occ_complete_geo_specimen.pdf
# 10      about/occ_complete_geo_observation.pdf
# 11      publishedby/occ_complete_specimen.pdf
# 12      publishedby/occ_complete_observation.pdf
# 13      publishedby/occ_repatriation.pdf
#########
countriesPerCsv=20
countryPath <- "report/country"
flagsPath <- "flags"
macHdName="Macintosh HD"
apiUrl="http://api.gbif-uat.org/v1/"

print("Generating kingdom matrix")
kingdomMatrix <- generateKingdomMatrix("hadoop/cr_kingdom_matrix.csv")
# these invocations mean the google api calls go out when this script is loaded
print("Generating traffic report")
trafficReport <- generateTrafficStats()
print("Generating traffic top 5 cities")
trafficTop5Cities <- generateTrafficTop5Cities()

# TODO: these take awhile, move to -runFigures
# print("Generating traffic weekly plots")
# generateTrafficWeeklyPlots()
print("Generating monthly download plots")
generateCountryDownloadsPlots()

# TODO: very slow outside secretariat
print("Generating publication stats")
pg1Research <- generatePublicationStats(apiUrl)
print("Generating pg1 pub blob")
pg1PubBlob <- generatePg1PubBlob()

print("Generating download stats")
pg3DownloadBlob <- generateCountryDownloadStats()
# TODO: slow outside secretariat
print("Generating latest publications")
pg3Pubs <- generateRecentPublications(apiUrl)

print("Generating class/phylum bubbles")
pg4TaxonMatrix <- generateClassPhylumMatrix("hadoop/cr_pg4_class_matrix.csv", "hadoop/cr_pg4_phylum_matrix.csv")

indesignMacPath <- function(hdName, absolutePath) {
  return(paste(hdName, gsub("/", ":", absolutePath), sep=""))
}

publishedBy <- function(country, filename, macPath) {
  return(paste(macPath, paste(country, paste(macPublishedBy, filename, sep=":"), sep=":"), sep=":"))
}

about <- function(country, filename, macPath) {
  return(paste(macPath, paste(country, paste(macAbout, filename, sep=":"), sep=":"), sep=":"))
}

countryReports <- function(country, filename, macPath) {
  return(paste(macPath, paste(country, paste(macCountryReports, filename, sep=":"), sep=":"), sep=":"))
}

writeCsv <- function(DF, header, filecount) {
  filename <- paste(paste("indesign_merge_mac_", filecount, sep=""), ".csv", sep="")
  write.csv(DF, filename, row.names=FALSE)    
}

joinWithOtherData <- function(DF) {
  DF <- merge(DF, kingdomMatrix, by = "CountryCode", all.x = TRUE)
  DF <- merge(DF, pg1Research, by = "CountryCode", all.x = TRUE)
  DF <- merge(DF, pg1PubBlob, by = "CountryCode", all.x = TRUE)
  # many countries haven't published, convert their NA to 0
  DF[is.na(DF)] <- 0
  DF <- merge(DF, trafficReport, by = "CountryCode", all.x = TRUE)
  DF <- merge(DF, trafficTop5Cities, by = "CountryCode", all.x = TRUE)
  DF <- merge(DF, pg3DownloadBlob, by = "CountryCode", all.x = TRUE)
  DF <- merge(DF, pg3Pubs, by = "CountryCode", all.x = TRUE)
  DF <- merge(DF, pg4TaxonMatrix, by = "CountryCode", all.x = TRUE)
  return(DF)
}

macFlagsPath <- indesignMacPath(macHdName, normalizePath(flagsPath))
macCountryPath <- indesignMacPath(macHdName, normalizePath(countryPath))

macAbout="about:print"
macPublishedBy="publishedBy:print"
macCountryReports="country_reports"

gbif_iso_countries()
# create csv with tmp header row
header=c("CountryCode","CountryName","@Flag","@Fig2","@Fig3","@Fig4","@Fig5","@Fig6","@Fig7","@Fig8","@Fig9","@Fig10","@Fig11","@Fig12","@Fig13")

# for every country in report/country add line to csv with mac specific path following:
countries <- list.dirs(path=countryPath, full.names=FALSE, recursive=FALSE)
count=0
filecount=0
DF<-header

for (country in countries) {
  count=count+1
  if (country %in% ISO_3166_1$Alpha_2) {
    print(paste("Preparing country: ", country, sep=""))
    row=c(country, 
          ISO_3166_1[ISO_3166_1$Alpha_2 == toupper(country),]$Name,
          paste(macFlagsPath, paste(tolower(country), ".png", sep=""), sep=":"),
          publishedBy(country, "occ_kingdom.pdf", macCountryPath), 
          countryReports(country, "web_traffic_sessions_by_week.pdf", macCountryPath),
          countryReports(country, "downloaded_records_by_month.pdf", macCountryPath),
          about(country, "occ_kingdom.pdf", macCountryPath), 
          about(country, "spe_kingdom.pdf", macCountryPath), 
          about(country, "occ_complete_kingdom_specimen.pdf", macCountryPath),
          about(country, "occ_complete_kingdom_observation.pdf", macCountryPath),
          about(country, "occ_complete_geo_specimen.pdf", macCountryPath),
          about(country, "occ_complete_geo_observation.pdf", macCountryPath),
          publishedBy(country, "occ_complete_specimen.pdf", macCountryPath),
          publishedBy(country, "occ_complete_observation.pdf", macCountryPath),
          publishedBy(country, "occ_repatriation.pdf", macCountryPath)
        )
    DF=rbind(DF, row)
  }
  if (count %% countriesPerCsv == 0) {
    # print(paste("Writing csv with country count at ", count, sep=""))
    filecount=filecount+1
    # remove the tmp header row and give proper colnames
    colnames(DF)=header
    DF <- DF[-c(1), ]
    DF <- joinWithOtherData(DF)
    writeCsv(DF, header, filecount)
    DF<-header
  }
}
# left over
filecount=filecount+1
colnames(DF)=header
DF <- DF[-c(1), ]
DF <- joinWithOtherData(DF)
# all NA to empty string
DF[is.na(DF)] <- ""
writeCsv(DF, header, filecount)
