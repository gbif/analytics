-- Hive query for page 7 top 8 datasets

CREATE DATABASE IF NOT EXISTS ${hiveconf:CR_DB};

DROP TABLE IF EXISTS ${hiveconf:CR_DB}.pg7_top8_datasets;

CREATE TABLE ${hiveconf:CR_DB}.pg7_top8_datasets
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT t2.country AS country, t2.dataset AS dataset, 
 t2.ct as ct, t2.rank_ AS rank FROM (
  
SELECT t1.country AS country, t1.datasetkey AS dataset, t1.ct AS ct, row_number() OVER (PARTITION BY t1.country ORDER BY t1.ct DESC) AS rank_ FROM 
(  
  SELECT count(o.gbifid) AS ct, o.countrycode AS country, o.datasetkey 
  FROM ${hiveconf:PROD_DB}.occurrence_hdfs o WHERE o.countrycode !=''
  GROUP BY o.countrycode, o.datasetkey )t1
) t2
WHERE t2.rank_ <= 8 ORDER BY country, rank, ct;

-- SELECT t1.country, t2.title, t1.ct, t1.rank FROM jan.top_contributing_datasets t1 JOIN 
-- jan.dataset_titles t2 ON t1.datasetkey = t2.key;
  