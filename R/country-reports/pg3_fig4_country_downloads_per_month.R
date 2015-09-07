# Page 3 - Fig4 downloaded records published by country, per month (call to registry postgres)
require(ggplot2)
require(plyr)
require(RMySQL)
require(RPostgreSQL)
require(dplyr)
source("R/html-json/utils.R")
source("R/graph/plot_utils.R")
# NOTE: you need to create a db_secrets.R that contains the following variables:
# Postgres prod registry
# ps_host
# ps_databaseName 
# ps_user 
# ps_password 
source("R/country-reports/db_secrets.R")

generateCountryDownloadsPlots <- function() {
  reportsDir <- "report/country"
  plotsDir <- "country_reports"
  plotName <- "downloaded_records_by_month"

  ps_sql <- "SELECT sum(dod.number_records), o.country, to_char(od.created, 'YYYY-MM') year_month FROM organization o
    JOIN dataset d ON d.publishing_organization_key = o.key
    JOIN dataset_occurrence_download dod ON d.key = dod.dataset_key
    JOIN occurrence_download od ON od.key = dod.download_key
    WHERE date(od.created) BETWEEN '2014-07-01' AND '2015-06-30'
    GROUP BY 2,3 ORDER BY 2,3"
  ps_con <- dbConnect(RPostgreSQL::PostgreSQL(), user=ps_user, password=ps_password, dbname=ps_databaseName, host=ps_host)
  downloadsDF <- dbGetQuery(ps_con, ps_sql)
  dbDisconnect(ps_con)
  
  colnames(downloadsDF) <- c("count", "CountryCode", "year_month")
  downloadsDF <- downloadsDF[!is.na(downloadsDF$CountryCode), ]
  
  # For every country; create a data frame and a plot based on that, then save .png
  for (country in unique(downloadsDF$CountryCode)) {
    bymonth <- downloadsDF[downloadsDF["CountryCode"]==country, ]
    # but only if there's data
    if (length(bymonth[[1]]) > 0) { 
      generateMonthlyDownloadPlot(bymonth, paste(paste(reportsDir, country, sep="/"), plotsDir, sep="/"), plotName)
    }
  }
}