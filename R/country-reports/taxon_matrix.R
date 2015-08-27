#...comment goes here

library(dplyr)
mycsv <- read.csv("kingdom_matrix.csv")

#The enforcer data frame is there to ensure consistent group size, i.e there will always be the same number of ranks per country
enforcer <- data.frame(country=character(), taxon=character(),stringsAsFactors = FALSE)

#Fills the enforcer with countries and taxon ranks
for (j in iso_country[,1]){
    for (k in unique(mycsv[,2])){        
        enforcer[nrow(enforcer)+1, ] <- c(j, k)
    }
}

#left_join from the dplyr package is used to join enforcer and mycsv. lapply and the as.character function coerces factors to char
combo <- data.frame(lapply(left_join(enforcer, mycsv, by=c('taxon'='t1.kingdom', 'country'='t1.country')), as.character), stringsAsFactors = F)
#converts NAs to 0
combo[is.na(combo)] <- 0

#Vectors for creating taxon columns in new data frame
fct <- as.character(unique(combo[,2]))
countries <- as.character(unique(combo[,1]))

df <- data.frame(countries)

for (j in fct){
    #each element in fct gets a new dataframe that is then pasted onto df
    newdf <- combo[combo$t2.kingdom == j, c('X_c2','X_c3')]
    for (k in colnames(newdf)){
        df[,paste(k,j, sep="")]<-newdf[,k]    
    }    
}

