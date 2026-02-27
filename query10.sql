WITH stop_neighborhood AS (
    SELECT
        s.stop_id,
        s.stop_name,
        s.geog,
        s.stop_lon,
        s.stop_lat,
        s.wheelchair_boarding,
        n.name AS neighborhood_name
    FROM septa.bus_stops s
    LEFT JOIN phl.neighborhoods n
      ON ST_Intersects(s.geog, n.geog)
)
SELECT
    stop_id,
    stop_name,
    'Stop located in ' || COALESCE(neighborhood_name, 'an unknown neighborhood') ||
    CASE
        WHEN wheelchair_boarding = 1 THEN ', accessible to wheelchair users'
        ELSE ''
    END AS stop_desc,
    stop_lon,
    stop_lat
FROM stop_neighborhood
ORDER BY stop_id;
