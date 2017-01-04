-- 2 tables for building the taxonomy bubbles on pg4 (one class table, one phylum table)

CREATE DATABASE IF NOT EXISTS ${hiveconf:CR_DB};

-- generate class counts for pg4 taxon matrix
DROP TABLE IF EXISTS ${hiveconf:CR_DB}.class_matrix;
CREATE TABLE ${hiveconf:CR_DB}.class_matrix
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT t1.country, t1.class_, sum(`_c2`)+sum(`_c3`),
CASE WHEN round((sum(`_c2`)/sum(`_c3`))*100) IS NULL THEN 'No prior occurrences' ELSE round((sum(`_c2`)/sum(`_c3`))*100) END AS increase
FROM
(
SELECT o1.countrycode AS country,  
  CASE WHEN o1.class IN ('Actinopterygii', 'Sarcopterygii') THEN 'Bony fish' 
       WHEN o1.class IN ('Ginkgoopsida','Pinopsida','Cycadopsida','Gnetopsida') THEN 'Conifers/cycads'
       WHEN o1.class IN ('Lycopodiopsida', 'Polypodiopsida', 'Equisetopsida', 'Psilotopsida', 'Marattiopsida') THEN 'Ferns'
       WHEN o1.class IN ('Liliopsida', 'Magnoliopsida') THEN 'Flowering plants'
  ELSE o1.class END AS class_,     
sum(if(to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int))) BETWEEN '${hiveconf:START_DATE}' AND '${hiveconf:END_DATE}',1,0)) ,
sum(if(to_date(from_unixtime(cast(o2.fragmentcreated/1000 AS int))) < '${hiveconf:START_DATE}',1,0))

FROM ${hiveconf:PROD_DB}.occurrence_hdfs o1 JOIN ${hiveconf:PROD_DB}.occurrence_hdfs o2 ON o1.gbifid = o2.gbifid
WHERE to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int))) <= '${hiveconf:END_DATE}'
AND (o1.classkey IN (359, 212, 204, 238, 131, 216, 358, 367, 245, 7228684, 228, 194, 282, 244, 246, 7219203, 7228682, 196, 220))
GROUP BY o1.countrycode, o1.class,
year(to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int)))),year(to_date(from_unixtime(cast(o2.fragmentcreated/1000 AS int))))
  )t1

GROUP BY t1.country, t1.class_;


-- generate phylum counts for pg4 taxon matrix
DROP TABLE IF EXISTS ${hiveconf:CR_DB}.phylum_matrix;
CREATE TABLE ${hiveconf:CR_DB}.phylum_matrix
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT t1.country, t1.phylum AS phylum, sum(`_c2`)+sum(`_c3`) AS total,
CASE WHEN round((sum(`_c2`)/sum(`_c3`))*100) IS NULL THEN 'No prior occurrences' ELSE round((sum(`_c2`)/sum(`_c3`))*100) END AS increase

FROM
(
SELECT o1.countrycode AS country,
o1.phylum AS phylum,
sum(if(to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int))) BETWEEN '${hiveconf:START_DATE}' AND '${hiveconf:END_DATE}',1,0)) ,
sum(if(to_date(from_unixtime(cast(o2.fragmentcreated/1000 AS int))) < '${hiveconf:START_DATE}',1,0))

FROM ${hiveconf:PROD_DB}.occurrence_hdfs o1 JOIN ${hiveconf:PROD_DB}.occurrence_hdfs o2 ON o1.gbifid = o2.gbifid
WHERE to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int))) <= '${hiveconf:END_DATE}'
AND (o1.phylumkey IN (52, 35, 95, 34))
GROUP BY o1.countrycode, o1.phylum,
year(to_date(from_unixtime(cast(o1.fragmentcreated/1000 AS int)))),year(to_date(from_unixtime(cast(o2.fragmentcreated/1000 AS int))))
)t1

GROUP BY t1.country, t1.phylum;
