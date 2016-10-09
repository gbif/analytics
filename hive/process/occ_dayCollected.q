CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;


DROP TABLE IF EXISTS ${hiveconf:DB}.occ_country_dayCollected;
CREATE TABLE ${hiveconf:DB}.occ_country_dayCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  country,
  dateDiff(
    concat_ws("-", CAST(year AS STRING), CAST(month AS STRING), CAST(day AS STRING)),
    concat_ws("-", CAST(year AS STRING), "01", "01")
  ) + 1 as day_of_year,
  COUNT(*) AS count
FROM ${hiveconf:DB}.snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL AND
  NOT (month = 2 AND day = 29)
GROUP BY snapshot,country,
dateDiff(
    concat_ws("-", CAST(year AS STRING), CAST(month AS STRING), CAST(day AS STRING)),
    concat_ws("-", CAST(year AS STRING), "01", "01")
  ) + 1;

DROP TABLE IF EXISTS ${hiveconf:DB}.occ_publisherCountry_dayCollected;
CREATE TABLE ${hiveconf:DB}.occ_publisherCountry_dayCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_country,
  dateDiff(
    concat_ws("-", CAST(year AS STRING), CAST(month AS STRING), CAST(day AS STRING)),
    concat_ws("-", CAST(year AS STRING), "01", "01")
  ) + 1 as day_of_year,
  COUNT(*) AS count
FROM ${hiveconf:DB}.snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL AND
  NOT (month = 2 AND day = 29)
GROUP BY snapshot,publisher_country,
dateDiff(
    concat_ws("-", CAST(year AS STRING), CAST(month AS STRING), CAST(day AS STRING)),
    concat_ws("-", CAST(year AS STRING), "01", "01")
  ) + 1;

-- Various occurrence counts rolled up as global count
DROP TABLE IF EXISTS ${hiveconf:DB}.occ_dayCollected;
CREATE TABLE ${hiveconf:DB}.occ_dayCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  day_of_year,
  SUM(count) AS count
FROM ${hiveconf:DB}.occ_country_dayCollected
GROUP BY snapshot,day_of_year;
