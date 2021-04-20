SET TIME ZONE 'UTC';

-- Count downloads per user per year
WITH dpupm AS (
     SELECT
       DATE_PART('year', od.created) AS year,
       SUM(total_records) AS totalRecords,
       COUNT(od.key) AS totalDownloads,
       username
     FROM occurrence_download od, public.user u
     WHERE od.created_by = u.username
     AND status IN('SUCCEEDED', 'FILE_ERASED') AND username NOT IN ('nagios')
     AND od.created < DATE_TRUNC('month', NOW())
     GROUP BY DATE_PART('year', od.created), username
)
-- Count distinct users for each year
SELECT dpupm.year, SUM(dpupm.totalRecords) AS "totalRecords", SUM(dpupm.totalDownloads) AS "totalDownloads", COUNT(DISTINCT dpupm.username) AS "totalUsers" FROM dpupm
GROUP BY year
ORDER BY year DESC;
