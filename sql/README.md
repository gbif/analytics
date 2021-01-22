# Monthly, annual and cumulative GBIF download statistics

A read-only account on the Registry database is required to run this.

Four tables are produced, including these columns:

* **totalRecords** is the number of occurrences records downloaded for just that country, month, and year
* **totalDownloads** is the number of successful downloads for just that country, month, and year
* **totalUsers** is the number of distinct users for just that country, month, and year
* **cumulativeAnnualUsers** is the number of distinct users for that country, month, and year (added cumulatively for each year).
