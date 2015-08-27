# Figure 3 - web traffic: sessions per week from country, for the last year

query.list <- Init(start.date = "2014-07-01",
                   end.date = "2015-06-30",                   
                   dimensions = "ga:countryIsoCode, ga:yearWeek, ga:yearMonth",
                   metrics = "ga:sessions",
                   #segment="users::condition::perSession::ga:timeOnPage>10",
                   max.results = 10000,
                   #sort = "ga:countryIsoCode, -ga:sessions",
                   table.id = "ga:73962076")
ga.query <- QueryBuilder(query.list)
ga.data <- GetReportData(ga.query, token)
