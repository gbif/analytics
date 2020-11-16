setwd("C:/Users/ftw712/Desktop/analytics/")

source("R/csv/cumlativeMonthlyDownloadStats/downloadRegistryTables.R")
source("R/csv/cumlativeMonthlyDownloadStats/monthlyStatistics.R")

library(RPostgres) # needed for database connection 
library(DBI) # needed for registry database connection 
library(dplyr) # for pipe %>%, filter, ect 
library(purrr) # for map

pw <- '' # password needed for registry 
user <- 'jwaller' # 
dir <- "R/csv/cumlativeMonthlyDownloadStats/"

# download registry tables 
registryTable <- downloadRegistryTables(pw,user) 

# compute and save csv tables
filename <- "downloadStatistcs.csv"
monthlyTotals(registryTable) %>% 
write.csv(paste(dir, filename, sep="/"), row.names=FALSE)

filename <- "downloadStatistcsCountry.csv"
monthlyTotalsCountry(registryTable) %>%
write.csv(paste(dir, filename, sep="/"), row.names=FALSE)
