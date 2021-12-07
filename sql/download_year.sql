SET TIME ZONE 'UTC';

-- Count downloads per user per year
WITH dpupm AS (
     SELECT
       DATE_PART('year', created) AS year,
       SUM(total_records) AS totalRecords,
       COUNT(key) AS totalDownloads,
       created_by AS username
     FROM occurrence_download
     WHERE status IN('SUCCEEDED', 'FILE_ERASED') AND created_by NOT IN ('nagios')
     AND created < DATE_TRUNC('month', NOW())
     GROUP BY DATE_PART('year', created), created_by
)
-- Count distinct users for each year
SELECT dpupm.year, SUM(dpupm.totalRecords) AS "totalRecords", SUM(dpupm.totalDownloads) AS "totalDownloads", COUNT(DISTINCT dpupm.username) AS "totalUsers" FROM dpupm
GROUP BY year
ORDER BY year DESC;
