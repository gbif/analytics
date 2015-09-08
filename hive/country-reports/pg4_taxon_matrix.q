-- 2 tables for building the taxonomy bubbles on pg4 (one class table, one phylum table)

CREATE DATABASE IF NOT EXISTS ${hiveconf:CR_DB};

-- generate class counts for pg4 taxon matrix
DROP TABLE IF EXISTS ${hiveconf:CR_DB}.class_matrix;
CREATE TABLE ${hiveconf:CR_DB}.class_matrix AS
SELECT t1.country, t1.class_, sum(`_c2`)+sum(`_c3`), 
CASE WHEN round((sum(`_c2`)/sum(`_c3`))*100) IS NULL THEN 'No prior occurrences' ELSE round((sum(`_c2`)/sum(`_c3`))*100) END AS increase
FROM
(
SELECT o1.countrycode AS country, 
  CASE WHEN o1.class IN ('Actinopterygii', 'Sarcopterygii') THEN 'Bony fish' ELSE o1.class END AS class_, 
sum(if(to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int))) BETWEEN '2014-07-01' AND '2015-06-30',1,0)) ,
sum(if(to_date(from_unixtime(cast(o2.fragmentcreated/1000 AS int))) < '2014-07-01',1,0)) 

FROM ${hiveconf:PROD_DB}.occurrence_hdfs o1 JOIN ${hiveconf:PROD_DB}.occurrence_hdfs o2 ON o1.gbifid = o2.gbifid 
WHERE to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int))) < '2015-07-01' 
AND (o1.classkey IN (359, 212, 204, 238, 131, 216, 358, 52, 367)) 
GROUP BY o1.countrycode, o1.class, 
year(to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int)))),year(to_date(from_unixtime(cast(o2.fragmentcreated/1000 AS int))))
  )t1

GROUP BY t1.country, t1.class_;


-- generate phylum counts for pg4 taxon matrix
DROP TABLE IF EXISTS ${hiveconf:CR_DB}.phylum_matrix;
CREATE TABLE ${hiveconf:CR_DB}.phylum_matrix AS 
SELECT t1.country, t1.phylum AS phylum, sum(`_c2`)+sum(`_c3`) AS total, 
CASE WHEN round((sum(`_c2`)/sum(`_c3`))*100) IS NULL THEN 'No prior occurrences' ELSE round((sum(`_c2`)/sum(`_c3`))*100) END AS increase 

FROM
(
SELECT o1.countrycode AS country, 
CASE WHEN o1.phylum IN ('Gnetophyta','Pinophyta','Cycadophyta','Ginkgophyta') THEN 'Conifers/cycads'
ELSE o1.phylum END AS phylum, 
sum(if(to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int))) BETWEEN '2014-07-01' AND '2015-06-30',1,0)) ,
sum(if(to_date(from_unixtime(cast(o2.fragmentcreated/1000 AS int))) < '2014-07-01',1,0)) 

FROM ${hiveconf:PROD_DB}.occurrence_hdfs o1 JOIN ${hiveconf:PROD_DB}.occurrence_hdfs o2 ON o1.gbifid = o2.gbifid 
WHERE to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int))) < '2015-07-01' 
AND (o1.phylumkey IN (11, 78, 101, 103, 49, 52, 59, 35, 95, 34)) 
GROUP BY o1.countrycode, o1.phylum, 
year(to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int)))),year(to_date(from_unixtime(cast(o2.fragmentcreated/1000 AS int))))
)t1

GROUP BY t1.country, t1.phylum;