# GBIF-country-reports
SQL and R scripts for generating the GBIF 2015 country report stats base file.

## Google Analytics
To run the pg2_traffic scripts you'll need a file called 'token_file' that contains the secrets needed to access the Google Analytics API. This uses OAuth 2 so you need credentials from the google developers console. With the same google account you use to view our analytics, go to http://console.developers.google.com and navigate to the APIs & Auth section, and choose Credentials. There create a new "OAuth 2.0 client ID" for Application type "Other". Use those in the code below. (For even more detail read here: https://cran.r-project.org/web/packages/RGA/vignettes/authorize.html)

Here is the RScript to use for generating the token (do not commit it!) :

```R
library(RGoogleAnalytics)

# your id from the analytics API, will look like <longrandomstring>.apps.googleusercontent.com
client.id <- "" 
# your secret for that id from the analytics API, looks like a long random string
client.secret <- ""
token <- Auth(client.id,client.secret)
save(token,file="R/country-reports/token_file")
```

Now the pg2_traffic scripts will load your token_file on each attempt to access the analytics API.

## MySQL and PostgreSQL (drupal and registry)
To run the scripts that talk to dbs directly you'll need to provide credentials in the form a of a file called R/country-reports/db_secrets.R. It needs to contain the following (with a couple of production hints filled in here):

```R
my_host <- "my1.gbif.org"
my_databaseName <- "drupal_live"
my_user <- ""
my_password <- ""

ps_host <- "pg1.gbif.org"
ps_databaseName <- "prod_b_registry"
ps_user <- ""
ps_password <- ""
```

## Default encoding
The machine that runs the R scripts must use UTF-8 or UTF-16 as the default encoding, to set the encoding and locale run the following command:

```
defaults write org.R-project.R force.LANG en_US.UTF-8
```

or using 

```
system("defaults write org.R-project.R force.LANG en_US.UTF-8")
```

The locale can be different to en_US as long the encoding is set to UTF-8.
