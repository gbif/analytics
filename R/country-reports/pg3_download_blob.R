# Pg3 download stats per country and globally. Needs users from drupal joined with downloads from reg.
require(RMySQL)
require(RPostgreSQL)
require(dplyr)
source("R/html-json/utils.R")
# NOTE: you need to create a db_secrets.R that contains the following variables:
# 
# MySQL prod drupal
# my_host 
# my_databaseName
# my_user 
# my_password 
# 
# Postgres prod registry
# ps_host
# ps_databaseName 
# ps_user 
# ps_password 
source("R/country-reports/db_secrets.R")

generateCountryDownloadStats <- function() {
  # Users table from drupal (mysql)
  my_sql <- "SELECT t1.usr, t1.mail, t1.country, t1.iso FROM (
  SELECT users.uid, users.name AS usr, field_data_field_firstname.field_firstname_value, 
    field_data_field_lastname.field_lastname_value,
    users.mail, users.created, users.login, 
    taxonomy_term_data.name AS country, field_data_field_iso2.field_iso2_value AS iso
  FROM users
  LEFT JOIN field_data_field_firstname ON field_data_field_firstname.entity_id = users.uid 
  LEFT JOIN field_data_field_lastname ON field_data_field_lastname.entity_id = users.uid 
  LEFT JOIN field_data_field_country_mono ON field_data_field_country_mono.entity_id = users.uid
  LEFT JOIN taxonomy_term_data ON taxonomy_term_data.tid = field_data_field_country_mono.field_country_mono_tid
  LEFT JOIN field_data_field_iso2 ON field_data_field_iso2.entity_id = taxonomy_term_data.tid
  WHERE users.login <> 0 AND users.mail NOT LIKE '%gbif.org'
  )t1;"
  my_con <- dbConnect(RMySQL::MySQL(), user=my_user, password=my_password, dbname=my_databaseName, host=my_host)
  usersDF <- dbGetQuery(my_con, my_sql)
  dbDisconnect(my_con)

  # filtered downloads table from registry (postgres)
  ps_sql <- "SELECT created_by FROM occurrence_download od
  WHERE od.status = 'SUCCEEDED' AND od.notification_addresses NOT LIKE '%@gbif.org' AND date(od.created) BETWEEN '2014-07-01' AND '2015-06-30';"
  ps_con <- dbConnect(RPostgreSQL::PostgreSQL(), user=ps_user, password=ps_password, dbname=ps_databaseName, host=ps_host)
  downloadsDF <- dbGetQuery(ps_con, ps_sql)
  dbDisconnect(ps_con)
  
  totalDownloadCount <- length(downloadsDF[[1]])
  
  #join the mysql and postgres tables to produce download count by country
  joined <- inner_join(usersDF, downloadsDF, by=c("usr"="created_by"))
  # approximate "select country, count(*) group by country"
  summarized <- joined %>% group_by(iso) %>% tally()
  
  # left join the result to the full country list
  gbif_iso_countries()
  countries <- data.frame(ISO_3166_1$Alpha_2, stringsAsFactors = FALSE)
  colnames(countries) <- c("iso")
  summarized <- left_join(countries, summarized, by="iso")
  # NA to 0
  summarized[is.na(summarized)] <- 0
  # add a percent of total
  summarized$country_download_percent_of_total <- round(summarized$n*100/totalDownloadCount, digits=2)
  colnames(summarized) <- c("CountryCode", "country_download_count", "country_download_percent_of_total")
  summarized$country_download_percent_of_total <- paste(summarized$country_download_percent_of_total, "%", sep="")
  summarized$country_download_count <- prettyNum(summarized$country_download_count, big.mark = ",")
 
  return(summarized) 
}