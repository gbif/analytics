source("R/cumlativeMonthlyDownloadStats/registryConnection.R")

# download registry tables 
downloadOccurrenceDownload <- function(con) {
  qs <- 'SELECT * FROM occurrence_download;'
  dbTable <- dbGetQuery(con,qs)
  return(dbTable)
}

downloadUser <- function(con) {
  qs <- "SELECT email, username as user, settings -> 'country' as country FROM public.user;"
  dbTable <- dbGetQuery(con,qs)
  return(dbTable)
}

downloadRegistryTables <- function(pw,user) {

	# connection to the registry database
	con <- registryConnection(pw,user) 

	# download registry tables
	downloadsTable <- downloadOccurrenceDownload(con) %>% 
		mutate(user = created_by) # duplicate the user column to join on
		
	userTable <- downloadUser(con) 

	# join tables in R. 
	# Could be done in SQL before (but I think there was a reason I did it this way)
	joinedRegistryTable <- merge(
		downloadsTable,
		userTable,
		id="user",
		all.x=TRUE) 

	# clean the joinedRegistryTable 
	cleanTable <- joinedRegistryTable %>% 
		mutate(month = lubridate::month(created)) %>% # extract month and year
		mutate(year = lubridate::year(created)) %>%
		mutate(monthYear = paste0(year,"-",month,"-15")) %>% # -15 use middle of month to not confuse date converstion
		mutate(total_records = as.numeric(total_records)) %>% # change to numeric because of very large int
		filter(!grepl("@gbif",notification_addresses)) %>% # remove internal users
		filter(!user == "nagios") %>% # remove nagios whale user
		filter(status == "SUCCEEDED") %>% # only successful downloads
		filter(!is.na(country)) %>% # remove without countries
		filter(!is.na(filter)) # remove those with no filter

	return(cleanTable)
}

