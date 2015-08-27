library(dplyr)
mycsv<-read.csv("phylum_matrix.csv", na.strings="NAN")
#enfor<-read.csv("speciesmatrix_group_enforce.csv", na.strings="NAN")
country<-as.character(unique(enfor[,1]))
countries<-data.frame(country)
combo<-left_join(countries,mycsv,by=c('country'='t1.country'),type="left")
combo<- data.frame(lapply(combo, as.character), stringsAsFactors = FALSE)
 combo[is.na(combo)]<-0
combo$t1.phylum[combo$t1.phylum == 0]<- "Mollusca"
df_phylum <- combo
colnames(df_phylum)[3:4]<-c("mollusca_c2","mollusca_c3")

 