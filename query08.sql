SELECT *
FROM phl.neighborhoods
WHERE mapname ILIKE '%university%';


CREATE EXTENSION IF NOT EXISTS postgis;
SELECT PostGIS_Version();


SET search_path = public, "$user", public;


SELECT name, ST_AsText(geog) AS geom_wkt
FROM phl.neighborhoods
WHERE mapname ILIKE '%university city%';
  
WITH ucity AS (
    SELECT geog
    FROM phl.neighborhoods
    WHERE mapname ILIKE '%University City%'
    LIMIT 1
)
SELECT
    COUNT(bg.geoid) AS count_block_groups
FROM census.blockgroups_2020 bg
JOIN ucity uc
  ON ST_DWithin(bg.geog, uc.geog, 0);  -- fully contained within the polygon
