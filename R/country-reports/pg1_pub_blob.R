# Page 1 occurrences published this year and all time. Requires csv file from hive/country-reports/pg1_pub_blob.q

generatePg1PubBlob <- function() {
  pub_blob <- read.csv("hadoop/cr_pg1_pub_blob.csv", na.strings="NAN")
  pub_blob[is.na(pub_blob)]<-0
  
  colnames(pub_blob) <- c("CountryCode", "pg1_pub_this_year", "pg1_pub_all_time")
  pub_blob$pg1_pub_this_year <- prettyNum(pub_blob$pg1_pub_this_year, big.mark = ",")
  pub_blob$pg1_pub_all_time <- prettyNum(pub_blob$pg1_pub_all_time, big.mark = ",")
  
  return(pub_blob)
}