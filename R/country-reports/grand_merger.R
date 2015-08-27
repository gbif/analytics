require(dplyr)
#iso_country <- read.csv("iso_countries.csv", encoding="UTF-8", na.strings="NAN") 
iso_country <- read.csv("country_iso_GBIF.csv", encoding="UTF-8", na.strings="NAN") 
iso_country[] <- lapply(iso_country, as.character)
#In case of UTF BOM
colnames(iso_country)[1] <- "iso_code"

merger0 <- right_join(df,iso_country, by=c('countries' = 'iso_code'))
merger1 <- left_join(merger0, df_phylum, by=c('countries' = 'country'), type="left")
merger2 <- left_join(merger1, df_class, by=c('countries' = 'countries'), type="left")

merger4 <- left_join(merger2, df_top10, by=c('countries' = 'countries'))
merger5 <- left_join(merger4, ga_prom, by=c('countries' = 'countryIsoCode'))
merger6 <- left_join(merger5, download_blob, by=c('countries' = 'iso_code'), na.strings="0")
merger7 <- left_join(merger6, df_top5, by=c('countries' = 'countries'), na.strings="0")
head(merger7, 10)
write.csv(merger4, "base_table.csv")

