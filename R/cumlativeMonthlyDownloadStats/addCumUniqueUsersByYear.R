# change with caution there was probably a reason I chose to do it this way 

getCumUniqueUsers <- function(index,data) {
  data <- data %>%
    arrange(desc(year),desc(month)) %>%
    pull(unique_users_list)

  output <- 1:index %>%
    map(~
          data[1:.x] %>%
          unlist() %>%
          unique() %>%
          length()
    ) %>%
    flatten_dbl()

}

addCumUniqueUsersByYear <- function(d) {

  data_list <- d %>%
    arrange(desc(year),desc(month)) %>%
    group_split(year)

  indexes <- data_list %>% map(~ .x %>% nrow())

  cumulative_unique_users_by_year <- map2(
	indexes,
	data_list,
	~getCumUniqueUsers(.x,.y)) %>%
    flatten_dbl() %>%
    rev()

  d <- d %>% mutate(cumulative_unique_users_by_year)
  return(d)
}

getCumUniqueUsersCountry <- function(index,data) {

  data_original = data

  data = data %>%
    arrange(desc(year),desc(month)) %>%
    pull(unique_users_list)

  cumulative_unique_users_by_year = 1:index %>%
    map(~
          data[1:.x] %>%
          unlist() %>%
          unique() %>%
          length()
    ) %>%
    flatten_dbl() %>%
    rev()

	data_original <- data_original %>%
		mutate(cumulative_unique_users_by_year)

  return(data_original)
}

addCumUniqueUsersByYearCountry <- function(d) {

  data_list <- d %>%
    arrange(desc(year),desc(month)) %>%
    group_split(year,country)

  indexes <- data_list %>% map(~ .x %>% nrow())

  cum_unique_users_by_year <- map2(
	indexes,
	data_list,
	~getCumUniqueUsersCountry(.x,.y)) %>%
    bind_rows()

  return(cum_unique_users_by_year)
}

