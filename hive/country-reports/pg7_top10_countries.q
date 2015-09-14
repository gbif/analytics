-- Page 7, table 3, top 10 countries contributing data about country

CREATE DATABASE IF NOT EXISTS ${hiveconf:CR_DB};

DROP TABLE IF EXISTS ${hiveconf:CR_DB}.pg7_top10_countries;

CREATE TABLE ${hiveconf:CR_DB}.pg7_top10_countries
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT t2.country AS country, t2.publisher AS publisher_country, t2.ct as ct, t2.rank_ AS rank FROM (
  SELECT t1.ccode AS country, t1.pubcode AS publisher, t1.ct AS ct, row_number() OVER (PARTITION BY t1.ccode ORDER BY t1.ct DESC) AS rank_ FROM 
  (
  SELECT count(o.gbifid) AS ct, o.publishingcountry AS pubcode, o.countrycode AS ccode FROM ${hiveconf:PROD_DB}.occurrence_hdfs o  
  WHERE o.countrycode IS NOT NULL AND o.countrycode <> 'ZZ' AND o.publishingcountry IS NOT NULL AND o.publishingcountry <> 'ZZ'
  GROUP BY o.countrycode, o.publishingcountry
  )t1 WHERE t1.ccode IS NOT NULL and t1.pubcode IS NOT NULL AND LENGTH(t1.ccode) = 2 and LENGTH(t1.pubcode) == 2
)t2
WHERE t2.rank_ <= 10
ORDER BY country, rank, ct, publisher_country;