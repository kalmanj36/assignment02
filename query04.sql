

CREATE EXTENSION IF NOT EXISTS postgis;
SELECT PostGIS_Version();


SET search_path = public, "$user", public;

WITH trip_geoms AS (
    SELECT
        t.trip_id,
        t.route_id,
        ST_MakeLine(ST_SetSRID(ST_MakePoint(s.shape_pt_lon, s.shape_pt_lat), 4326) 
                    ORDER BY s.shape_pt_sequence) AS geom
    FROM septa.bus_trips t
    JOIN septa.bus_shapes s
      ON t.shape_id = s.shape_id
    GROUP BY t.trip_id, t.route_id
)
SELECT *
FROM trip_geoms
ORDER BY ST_Length(geom::geography) DESC
LIMIT 2;



