library(dplyr)
mycsv<-read.csv("class_matrix.csv", na.strings="NAN")
enfor<-read.csv("class_matrix_group_enforce.csv", na.strings="NAN")
combo<-left_join(enfor,mycsv,by=c('t2.class_'='class_matrix.class_', 't1.iso_code'='class_matrix.country'),type="left")
combo<- data.frame(lapply(combo, as.character), stringsAsFactors = FALSE)
combo[is.na(combo)]<-0

fct<-as.character(unique(combo[,2]))
countries<-as.character(unique(combo[,1]))

df_class<-data.frame(countries)

for (j in fct){
    newdf<-combo[combo$t2.class_==j, c('class_matrix._c2','class_matrix._c3')]
    for (k in colnames(newdf)){
        #print(k)
        #print(head(newdf[,k]))
        df_class[,paste(k,j, sep="")]<-newdf[,k]    
    }    
}

#combo[combo$t2.kingdom=="Animalia",c('X_c2','X_c3')]