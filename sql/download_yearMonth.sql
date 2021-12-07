SET TIME ZONE 'UTC';

-- Count downloads per user per month
WITH dpupm AS (
     SELECT
       DATE_PART('year', created) AS year,
       DATE_PART('month', created) AS month,
       SUM(total_records) AS totalRecords,
       COUNT(key) AS totalDownloads,
       created_by AS username
     FROM occurrence_download
     WHERE status IN('SUCCEEDED', 'FILE_ERASED') AND created_by NOT IN ('nagios')
     AND created < DATE_TRUNC('month', NOW())
     GROUP BY DATE_PART('year', created), DATE_PART('month', created), created_by
),
-- Label each user's monthly download count sequentially (1 for the first month they make at least one download, 2 for the second etc)
sudc AS (
SELECT sud.*, SUM(CASE WHEN seqnum = 1 THEN 1 ELSE 0 END) OVER (PARTITION BY year ORDER BY month) AS cum_distinct_username FROM (
       SELECT dpupm.*, ROW_NUMBER() OVER (PARTITION BY year, username ORDER BY YEAR, MONTH) AS seqnum
       FROM dpupm
) sud
)
-- Count distinct users for each month (independently), and take the cumulative (by year) user count.
SELECT sudc.year, sudc.month, SUM(sudc.totalRecords) AS "totalRecords", SUM(sudc.totalDownloads) AS "totalDownloads", COUNT(DISTINCT sudc.username) AS "totalUsers", MAX(cum_distinct_username) AS "cumulativeAnnualUsers" FROM sudc
GROUP BY year, month
ORDER BY year DESC, month DESC;
