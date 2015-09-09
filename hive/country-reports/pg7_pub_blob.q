-- For the page 7 'publishing data about' blob

CREATE DATABASE IF NOT EXISTS ${hiveconf:CR_DB};

DROP TABLE IF EXISTS ${hiveconf:CR_DB}.pg7_pub_blob;

CREATE TABLE ${hiveconf:CR_DB}.pg7_pub_blob
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT  publishingcountry, count(DISTINCT countrycode) AS data_from, count(gbifid) AS records, count(DISTINCT datasetkey) AS datasets 
FROM ${hiveconf:PROD_DB}.occurrence_hdfs
GROUP BY publishingcountry