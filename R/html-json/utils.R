# install.packages("ISOcodes")
library(ISOcodes)

country_lists <- function() {
  # The index home page
  # Rewrite the iso values to names
  data("ISO_3166_1")
  
  # apply the GBIF modifications to country names
  ISO_3166_1$Name[ISO_3166_1$Alpha_2 == "TW"] <- "Chinese Taipei"
  
  about_iso <- c()
  about_names <- c()
  publishing_iso <- c()
  publishing_names <- c()
  countries <- list.dirs(path="report/country", full.names=FALSE, recursive=FALSE)
  # remove "null" country
  countries <- countries[which(countries!="null")] 
  for (c in countries) {  
    types <- list.dirs(path=paste("report/country", c, sep="/"), full.names=FALSE, recursive=FALSE)
    name <- ISO_3166_1[ISO_3166_1$Alpha_2 == toupper(c),]$Name
    if ('about' %in% types) {
      about_iso <- append(about_iso, c)
      about_names <- append(about_names, name)
    }
    if ('publishedBy' %in% types) {
      publishing_iso <- append(publishing_iso, c)
      publishing_names <- append(publishing_names, name)
    }
  }
  
  # convert them into dataframes
  about_countries <- data.frame(about_iso, about_names)  
  publishing_countries <- data.frame(publishing_iso, publishing_names)
  colnames(about_countries) <- c("iso", "title")
  colnames(publishing_countries) <- c("iso", "title")
  
  # sort them alphabetically
  about_countries <- about_countries[order(about_countries$title) , ]
  publishing_countries <- publishing_countries[order(publishing_countries$title) , ]

  country_lists <- list("about"=about_countries, "publishing"=publishing_countries) 
  return(country_lists) 
}