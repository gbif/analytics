
# connect to the registry with some defaults 
registryConnection <- function(
	pw,
	user="jwaller",
	host="pg1.gbif.org",
	port="5432",
	dbname="prod_b_registry") {

	con <- dbConnect(RPostgres::Postgres(),
					host=host,
					port=port,
					dbname=dbname,
					user=user,
					password=pw)

	return(con)
}


