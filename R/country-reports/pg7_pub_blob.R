# Page 7 data published from blob. Requires csv file from hive/country-reports/pg7_pub_blob.q

generatePg7PubBlob <- function() {
  pub_blob <- read.csv("hadoop/cr_pg7_pub_blob.csv", na.strings="NAN")
  pub_blob[is.na(pub_blob)]<-0
  
  colnames(pub_blob) <- c("CountryCode", "pg7_pub_from_country_count", "pg7_pub_from_occ_count", "pg7_pub_from_dataset_count")
  pub_blob$pg7_pub_from_occ_count <- prettyNum(pub_blob$pg7_pub_from_occ_count, big.mark = ",", preserve.width = "individual")
  pub_blob$pg7_pub_from_dataset_count <- prettyNum(pub_blob$pg7_pub_from_dataset_count, big.mark = ",", preserve.width = "individual")
  
  return(pub_blob)
}