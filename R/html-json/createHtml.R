library(whisker)
library(plyr)
source("R/html-json/utils.R")

# copy the assets across
file.copy(from="R/html-json/assets", to="report", recursive=TRUE)

countries <- country_lists()
about_countries <- countries[[1]]
publishing_countries <- countries[[2]]

# split them up into nicely sorted groups to display as 4 columns
rowsPerCol <- nrow(about_countries) / 4
abouts <- split(about_countries, (0:nrow(about_countries) %/% rowsPerCol))
rowsPerCol <- nrow(publishing_countries) / 4
pubs <- split(publishing_countries, (0:nrow(publishing_countries) %/% rowsPerCol))

data <- list( 
  assets  = "./assets",
  rootPath  = ".",
  about_1 = unname(rowSplit(abouts[1][[1]])),
  about_2 = unname(rowSplit(abouts[2][[1]])),
  about_3 = unname(rowSplit(abouts[3][[1]])),
  about_4 = unname(rowSplit(abouts[4][[1]])),
  pub_1 = unname(rowSplit(pubs[1][[1]])),
  pub_2 = unname(rowSplit(pubs[2][[1]])),
  pub_3 = unname(rowSplit(pubs[3][[1]])),
  pub_4 = unname(rowSplit(pubs[4][[1]]))
)
template <- readLines("R/html-json/home-template.html")
writeLines(whisker.render(template, data), "report/index.html")

# Faq
data <- list( 
  assets  = "./assets",
  rootPath  = "."
)
template <- readLines("R/html-json/faq-template.html")
writeLines(whisker.render(template, data), "report/faq.html")

# Global report
data <- list( 
  assets  = "../assets",
  rootPath  = "..",
  title = "Global data trends",
  description = "Summarizing the data available in the GBIF index over time.",
  datasharingDescription = "This chart shows the total number of records published through GBIF over time, with separate colours for records published from within the country where the species occurred, and those shared by publishers from other countries."
)
template <- readLines("R/html-json/index-template.html")
writeLines(whisker.render(template, data), "report/global/index.html")

countries <- list.dirs(path="report/country", full.names=FALSE, recursive=FALSE)
for (c in countries) {  
  name <- ISO_3166_1[ISO_3166_1$Alpha_2 == toupper(c),]$Name
  if (length(name) == 0) {
    name <- paste("ISO [", toupper(c), "]", sep="")
  }  
  # expecting "about" and "publishedBy" as types
  types <- list.dirs(path=paste("report/country", c, sep="/"), full.names=FALSE, recursive=FALSE)
  for (type in types) {
    action <- "about";
    if ('publishedBy' == type) {
      action <- "published by institutions within";
      datasharingDescription <- paste(
        "This chart shows the number of records shared by publishers within", 
        name, 
        "over time, with separate colours for records about species occurring in", 
        name, 
        "and those occurring in other countries."
        )
    } else {
      datasharingDescription <- paste(
        "This chart shows the number of records about biodiversity occurring in ", 
        name, 
        ", with separate colours for records published from within ", 
        name, 
        ", and those shared by publishers from other countries.",
        sep=""
      )
    }
    
    data <- list( 
      assets  = "../../../assets",
      rootPath  = "../../..",
      title = paste(name, "data trends"),
      description = paste("Summarizing the data", 
                          action, name, 
                          "available in the GBIF index over time."),
      datasharingDescription = datasharingDescription
    )
    template <- readLines("R/html-json/index-template.html")
    writeLines(whisker.render(template, data), paste("report/country/", c, type, "index.html", sep="/"))
  }
}