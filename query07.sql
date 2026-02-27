CREATE EXTENSION IF NOT EXISTS postgis;
SELECT PostGIS_Version();


SET search_path = public, "$user", public;

WITH stop_counts AS (
    SELECT
        n.name AS neighborhood_name,
        COUNT(s.stop_id) AS total_stops,
        SUM(CASE WHEN s.wheelchair_boarding = 1 THEN 1 ELSE 0 END) AS accessible_stops,
        ROUND((SUM(CASE WHEN s.wheelchair_boarding = 1 THEN 1 ELSE 0 END)::numeric / COUNT(s.stop_id)) * 100, 2) AS accessibility_pct
    FROM phl.neighborhoods n
    JOIN septa.bus_stops s
      ON ST_DWithin(s.geog, n.geog, 0)
    GROUP BY n.name
)
SELECT *
FROM stop_counts
ORDER BY accessibility_pct ASC
LIMIT 5;
