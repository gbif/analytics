-- Set up memory for YARN
SET mapreduce.map.memory.mb = 4096;
SET mapreduce.reduce.memory.mb = 4096;
SET mapreduce.map.java.opts = -Xmx3072m;
SET mapreduce.reduce.java.opts = -Xmx3072m;

CREATE DATABASE IF NOT EXISTS ${hiveconf:DB};

-- Increase the memory for this job which is memory intensive.
-- mapreduce.map.java.opts must be set otherwise the cluster wide default is used.
-- mapreduce.map.memory.mb must be set so Yarn knows how to calculate if resources are being overutilised.
-- If mapreduce.map.memory.mb is not set, you will likely see Yarn kill the job with errors such as
-- "is running beyond physical memory limits. Current usage: 1.0 GB of 1 GB physical memory used; 2.4 GB of 2.1 GB virtual memory used. Killing container."
-- Notice that the Xmx must be set at around 85% of the map.memory to allow for overhead.
SET mapreduce.map.memory.mb=2048;
SET mapreduce.map.java.opts=-Djava.net.preferIPv4Stack=true -Xmx1700M;

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_country_yearCollected;
CREATE TABLE ${hiveconf:DB}.spe_country_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  country,
  year,
  COUNT(DISTINCT species_id) AS count
FROM ${hiveconf:DB}.snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,country,year;

DROP TABLE IF EXISTS ${hiveconf:DB}.spe_publisherCountry_yearCollected;
CREATE TABLE ${hiveconf:DB}.spe_publisherCountry_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  publisher_country,
  year,
  COUNT(DISTINCT species_id) AS count
FROM ${hiveconf:DB}.snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,publisher_country,year;

-- Various occurrence counts rolled up as global country
DROP TABLE IF EXISTS ${hiveconf:DB}.spe_yearCollected;
CREATE TABLE ${hiveconf:DB}.spe_yearCollected
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
AS SELECT
  snapshot,
  year,
  COUNT(DISTINCT species_id) AS count
FROM ${hiveconf:DB}.snapshots
WHERE year IS NOT NULL AND species_id IS NOT NULL
GROUP BY snapshot,year;
