# Table 3 - data mobilization : top 10 contributors about country
require(dplyr)
topp <- read.csv("tab3_top_10_data_contributors_about_country.csv", na.strings="")

mylink <- c(unique(as.character(topp[,1])))
mylink=mylink[-1]

enfor <- data.frame(country=character(), rank=integer(), stringsAsFactors = FALSE)

for (j in 1:10){
    for (k in mylink){
        #print(c(k, j))
        enfor[nrow(enfor)+1, ] <- c(k, j)
    }
}
enfor$rank = as.integer(enfor$rank)

top_contributors <- data.frame(lapply(left_join(enfor, topp,by=c('country'='country', 'rank'='rank')), as.character), stringsAsFactors = FALSE)
top_contributors[is.na(top_contributors)] <- ""

fct<-as.character(unique(top_contributors[,2]))
countries<-as.character(unique(top_contributors[,1]))

df_top10<-data.frame(countries)

for (j in fct){
    newdf<-top_contributors[top_contributors$rank==j, c('publisher_country','ct')]
    for (k in colnames(newdf)){
        #print(k)
        #print(head(newdf[,k]))
        df_top10[,paste(k,j, sep="")]<-newdf[,k]    
    }    
}
