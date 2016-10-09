CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;


DROP TABLE IF EXISTS ${hiveconf:DB}.spe_country_dayCollected;
CREATE TABLE ${hiveconf:DB}.spe_country_dayCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  country,
  dateDiff(
    concat_ws("-", CAST(year AS STRING), CAST(month AS STRING), CAST(day AS STRING)),
    concat_ws("-", CAST(year AS STRING), "01", "01")
  ) + 1 as day_of_year,
  COUNT(DISTINCT species_id) AS count
FROM ${hiveconf:DB}.snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL AND
  NOT (month = 2 AND day = 29) AND
  species_id IS NOT NULL
GROUP BY snapshot,country,
dateDiff(
    concat_ws("-", CAST(year AS STRING), CAST(month AS STRING), CAST(day AS STRING)),
    concat_ws("-", CAST(year AS STRING), "01", "01")
  ) + 1;

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_publisherCountry_dayCollected;
CREATE TABLE ${hiveconf:DB}.spe_publisherCountry_dayCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_country,
  dateDiff(
    concat_ws("-", CAST(year AS STRING), CAST(month AS STRING), CAST(day AS STRING)),
    concat_ws("-", CAST(year AS STRING), "01", "01")
  ) + 1 as day_of_year,
  COUNT(DISTINCT species_id) AS count
FROM ${hiveconf:DB}.snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL AND
  NOT (month = 2 AND day = 29) AND
  species_id IS NOT NULL
GROUP BY snapshot,publisher_country,
dateDiff(
    concat_ws("-", CAST(year AS STRING), CAST(month AS STRING), CAST(day AS STRING)),
    concat_ws("-", CAST(year AS STRING), "01", "01")
  ) + 1;

-- Various occurrence counts rolled up as global count
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_dayCollected;
CREATE TABLE ${hiveconf:DB}.spe_dayCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  dateDiff(
    concat_ws("-", CAST(year AS STRING), CAST(month AS STRING), CAST(day AS STRING)),
    concat_ws("-", CAST(year AS STRING), "01", "01")
  ) + 1 as day_of_year,
  COUNT(DISTINCT species_id) AS count
FROM ${hiveconf:DB}.snapshots
WHERE
  day IS NOT NULL AND
  month IS NOT NULL AND
  year IS NOT NULL AND
  NOT (month = 2 AND day = 29) AND
  species_id IS NOT NULL
GROUP BY snapshot,
dateDiff(
    concat_ws("-", CAST(year AS STRING), CAST(month AS STRING), CAST(day AS STRING)),
    concat_ws("-", CAST(year AS STRING), "01", "01")
  ) + 1;
