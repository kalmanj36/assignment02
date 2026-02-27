-- Step 1: Count total stops and accessible stops per neighborhood
CREATE EXTENSION IF NOT EXISTS postgis;
SELECT PostGIS_Version();


SET search_path = public, "$user", public;


WITH stop_counts AS (
    SELECT
        n.name AS neighborhood_name,
        COUNT(s.stop_id) AS total_stops,
        SUM(CASE WHEN s.wheelchair_boarding = 1 THEN 1 ELSE 0 END) AS accessible_stops
    FROM phl.neighborhoods n
    JOIN septa.bus_stops s
      ON ST_Contains(
            n.geog::geometry,  -- cast geography → geometry
            s.geog::geometry
         )
    GROUP BY n.name
)
SELECT
    neighborhood_name,
    total_stops,
    accessible_stops,
    ROUND((accessible_stops::numeric / total_stops) * 100, 2) AS accessibility_pct
FROM stop_counts
ORDER BY accessibility_pct DESC;
