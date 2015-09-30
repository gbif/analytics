# GBIF-country-reports
SQL and R scripts for generating the GBIF 2015 country report stats base file.

TODO: parameterize the start and end dates for this reporting run

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
