source("R/cumlativeMonthlyDownloadStats/addCumUniqueUsersByYear.R")

# input the clean downloaded registry tables
monthlyTotals <- function(registryTable) {

	monthly_totals <- registryTable %>%
		group_by(month,year) %>%
		summarise(Records=sum(total_records,na.rm=TRUE),Downloads=n(),Users=n_distinct(user),unique_users_list=list(unique(user))) %>%
		ungroup() %>%
		arrange(desc(year),month) %>%
		group_by(year) %>%
		mutate(cumulative_downloads_by_year = cumsum(Downloads)) %>%
		mutate(cumulative_records_downloaded_by_year = cumsum(Records)) %>%
		ungroup() %>%
		arrange(desc(year),desc(month)) %>%
		addCumUniqueUsersByYear() %>% # complicated cumulative distinct user counts
		select(-unique_users_list) # remove list column

	return(monthly_totals)
}

monthlyTotalsCountry <- function(registryTable) {

	monthly_totals_country <- registryTable %>%
		group_by(month,year,country) %>%
		summarise(Records=sum(total_records,na.rm=TRUE),Downloads=n(),Users=n_distinct(user),unique_users_list=list(unique(user))) %>%
		ungroup() %>%
		arrange(desc(year),month) %>%
		group_by(year,country) %>%
		mutate(cumulative_downloads_by_year = cumsum(Downloads)) %>%
		mutate(cumulative_records_downloaded_by_year = cumsum(Records)) %>%
		ungroup() %>%
		addCumUniqueUsersByYearCountry() %>% # complicated stats
		arrange(desc(year),desc(month),country) %>%
		select(-unique_users_list) # remove list column

	return(monthly_totals_country)
}

