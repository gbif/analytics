-- Base table for kingdom matrix (pg 1 taxonomy bubbles). Result used by taxon_matrix.R

CREATE DATABASE IF NOT EXISTS ${hiveconf:CR_DB};

DROP TABLE IF EXISTS ${hiveconf:CR_DB}.kingdom_matrix;

CREATE TABLE ${hiveconf:CR_DB}.kingdom_matrix
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE 
AS SELECT t1.country, t1.kingdom , sum(`_c2`)+sum(`_c3`), 
CASE WHEN round((sum(`_c2`)/sum(`_c3`))*100) IS NULL THEN '-' ELSE round((sum(`_c2`)/sum(`_c3`))*100) END AS increase

FROM
(
SELECT o1.countrycode AS country, o1.kingdom AS kingdom, 
sum(if(to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int))) BETWEEN '2014-07-01' AND '2015-06-30',1,0)) ,
sum(if(to_date(from_unixtime(cast(o2.fragmentcreated/1000 AS int))) < '2014-07-01',1,0)) 

FROM ${hiveconf:PROD_DB}.occurrence_hdfs o1 JOIN ${hiveconf:PROD_DB}.occurrence_hdfs o2 ON o1.gbifid = o2.gbifid 
WHERE to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int))) < '2015-07-01' 
AND (o1.kingdomkey IN (1,6,5,7,3,8,4,2)) 
GROUP BY o1.countrycode, o1.kingdom, 
year(to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int)))),year(to_date(from_unixtime(cast(o2.fragmentcreated/1000 AS int))))
) t1

GROUP BY t1.country, t1.kingdom

UNION ALL

SELECT t1.country, 
CASE WHEN t1.kingdom = '' THEN 'Unknown' ELSE t1.kingdom END AS kingdom, 
sum(`_c2`)+sum(`_c3`), 
CASE WHEN round((sum(`_c2`)/sum(`_c3`))*100) IS NULL THEN '-' ELSE round((sum(`_c2`)/sum(`_c3`))*100) END AS increase

FROM
(
SELECT o1.countrycode AS country, o1.kingdom AS kingdom, 
sum(if(to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int))) BETWEEN '2014-07-01' AND '2015-06-30',1,0)) ,
sum(if(to_date(from_unixtime(cast(o2.fragmentcreated/1000 AS int))) < '2014-07-01',1,0)) 

FROM ${hiveconf:PROD_DB}.occurrence_hdfs o1 JOIN ${hiveconf:PROD_DB}.occurrence_hdfs o2 ON o1.gbifid = o2.gbifid 
WHERE to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int))) < '2015-07-01' 
AND  o1.kingdomkey IS NULL AND o1.phylumkey IS NULL AND o1.classkey IS NULL AND o1.orderkey IS NULL AND o1.familykey IS NULL and o1.genuskey IS NULL and o1.specieskey IS NULL

GROUP BY o1.countrycode, o1.kingdom, 
year(to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int)))),year(to_date(from_unixtime(cast(o2.fragmentcreated/1000 AS int))))
) t1

GROUP BY t1.country, t1.kingdom