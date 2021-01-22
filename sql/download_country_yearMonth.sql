SET TIME ZONE 'UTC';

-- Count downloads per user per month
WITH dpupm AS (
     SELECT
       DATE_PART('year', od.created) AS year,
       DATE_PART('month', od.created) AS month,
       settings->'country' AS country,
       SUM(total_records) AS totalRecords,
       COUNT(od.key) AS totalDownloads,
       username
     FROM occurrence_download od, public.user u WHERE od.created_by = u.username
     AND status IN('SUCCEEDED', 'FILE_ERASED') AND username NOT IN ('nagios')
     GROUP BY DATE_PART('year', od.created), DATE_PART('month', od.created), country, username
),
-- Label each user's monthly download count sequentially (1 for the first month they make at least one download, 2 for the second etc)
sudc AS (
SELECT sud.*, SUM(CASE WHEN seqnum = 1 THEN 1 ELSE 0 END) OVER (PARTITION BY year, country ORDER BY month) AS cum_distinct_username FROM (
       SELECT dpupm.*, ROW_NUMBER() OVER (PARTITION BY year, country, username ORDER BY year, month) AS seqnum
       FROM dpupm
) sud
)
-- Count distinct users for each month (independently), and take the cumulative (by year) user count.
SELECT sudc.year, sudc.month, sudc.country, SUM(sudc.totalRecords) AS "totalRecords", SUM(sudc.totalDownloads) AS "totalDownloads", COUNT(DISTINCT sudc.username) AS "totalUsers", MAX(cum_distinct_username) AS "cumulativeAnnualUsers" FROM sudc
GROUP BY year, month, country
ORDER BY year DESC, month DESC;
