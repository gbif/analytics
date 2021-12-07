SET TIME ZONE 'UTC';

-- Count downloads per user per year
WITH dpupm AS (
     SELECT
       DATE_PART('year', od.created) AS year,
       COALESCE(settings->'country', 'ZZ') AS userCountry,
       SUM(total_records) AS totalRecords,
       COUNT(od.key) AS totalDownloads,
       username
     FROM occurrence_download od LEFT JOIN public.user u ON od.created_by = u.username
     WHERE status IN('SUCCEEDED', 'FILE_ERASED') AND username NOT IN ('nagios')
     AND od.created < DATE_TRUNC('month', NOW())
     GROUP BY DATE_PART('year', od.created), userCountry, username
)
-- Count distinct users for each year
SELECT dpupm.year, dpupm.userCountry AS "userCountry", SUM(dpupm.totalRecords) AS "totalRecords", SUM(dpupm.totalDownloads) AS "totalDownloads", COUNT(DISTINCT dpupm.username) AS "totalUsers" FROM dpupm
GROUP BY year, userCountry
ORDER BY year DESC;
