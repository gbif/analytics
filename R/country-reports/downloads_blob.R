# Downloads: this fills the blob beside Figure 4
library(dplyr)
download_blob<-read.csv("downloads_blob.csv", na.strings="NAN")
iso_country <- read.csv("country_iso_GBIF.csv", encoding="UTF-8", na.strings="NAN") 

download_blob <- left_join(iso_country, download_blob, by=c('iso_code'='iso_code'),type="left")

download_blob[is.na(download_blob)]<-0

str(download_blob)

