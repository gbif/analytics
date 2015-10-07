library(reshape2)
library(plyr)

# the location of the files exported from Hadoop
sourceDir <- "hadoop"

# the location where  CSVs should be processed to
targetDir <- "report"

# TODO seems we get "null" as well for publishing country?  See reports directory names within countries
NULL_STRING = "\\N" 

##
# Takes a DF, splits it by the groupTerm, creates a directory (parentDir/<GROUP_TERM>/childDir),
# removes the group term from the DF, and writes a csv named filename for the group with headers 
# the same as the names of the columns in the DF.  Anything with NULL is ignored.
#
writeCsvPerGroup <- function(DF, groupTerm, filename, parentDir, childDir) {
  DF <- split(DF, DF[,groupTerm]) 
  
  for(i in 1:length(DF)) {
    group <- DF[[i]]    
    key <- group[1,groupTerm]
    if (!key == NULL_STRING) {
      # remove group column
      drops <- c(groupTerm)
      group <- group[,!(names(group) %in% drops)]  
      dir <- paste(targetDir,parentDir,key,childDir, "csv", sep="/")
      dir.create(dir, showWarnings=FALSE, recursive=TRUE)
      write.csv(group, paste(dir, filename, sep="/"), row.names=FALSE)
    }
  }
}

##
# Utility to extract the provided groups from the source CSV and write the target CSVs
#


# testing, remove
# sourceFile <- "occ_country_kingdom_basisOfRecord.csv"
# sourceSchema <- c("snapshot", "country", "kingdom", "basisOfRecord", "occurrenceCount")
# targetFile <- "occ_kingdom_basisOfRecord.csv"
# group <- c("country")
# groupLabel <- c("about")

extractCountryCSV <- function(sourceFile, sourceSchema, targetFile, group, groupLabel) {
  writeCsvPerGroup(
    DF = read.table(file=paste(sourceDir, sourceFile, sep="/"), header=F, sep=",",  col.names = sourceSchema, na.strings="FOO"),
    groupTerm = group, 
    filename = targetFile, 
    parentDir = "country", 
    childDir = groupLabel)
}

##
# Utility to process a CSV into the global directory and add the header
#
prepareGlobalCSV <- function(sourceFile, sourceSchema, targetFile) {
  t <- read.table(file=paste(sourceDir, sourceFile, sep="/"), header=F, sep=",",  col.names = sourceSchema)
  dir <- paste(targetDir,"global", "csv", sep="/")
  dir.create(dir, showWarnings=FALSE, recursive=TRUE)
  write.csv(t, paste(dir, targetFile, sep="/"), row.names=FALSE)
}