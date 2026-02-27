CREATE EXTENSION IF NOT EXISTS postgis;
SELECT PostGIS_Version();


SET search_path = public, "$user", public;


SELECT stop_name, geog
FROM septa.bus_stops
WHERE stop_name ILIKE '%Walnut St & 34th St%';



WITH meyerson AS (
    SELECT geog
    FROM septa.bus_stops
    WHERE stop_name ILIKE '%Walnut St & 34th St%'  -- Meyerson Hall stop name
    LIMIT 1
)
SELECT bg.geoid AS geo_id
FROM census.blockgroups_2020 bg
JOIN meyerson m
  ON ST_Intersects(bg.geog, m.geog)  -- use intersects instead of contains
LIMIT 1;
