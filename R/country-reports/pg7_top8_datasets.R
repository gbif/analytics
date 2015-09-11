# page 7, top 8 datasets contributing about country
require(dplyr)
# topp <- read.csv("../Page7_top_contrib_for_R.csv", na.strings="", encoding="UTF-8")
topp <- read.csv("hadoop/cr_pg7_top8_datasets.csv", na.strings="", encoding="UTF-8")

#without the enforcer the groups are not consistent
enforcer <- data.frame(country=character(), rank=integer(), stringsAsFactors = FALSE)

for (j in 1:8){
  for (k in iso_country$iso_code){        
    enforcer[nrow(enforcer)+1, ] <- c(k, j)
  }
}
enforcer$rank = as.integer(enforcer$rank)

top_contributors <- data.frame(lapply(left_join(enforcer, topp,by=c('country'='country', 'rank'='rank')), as.character), stringsAsFactors = FALSE)
top_contributors[is.na(top_contributors)] <- ""

fct<-as.character(unique(top_contributors$rank))
countries<-as.character(unique(top_contributors$country))

df_top8_contributing<-data.frame(countries)

for (j in fct){
  newdf<-top_contributors[top_contributors$rank==j, c('title','count')]
  for (k in colnames(newdf)){
    df_top8_contributing[,paste(k, "rank",j , sep="_")]<-newdf[,k]    
  }    
}