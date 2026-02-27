SELECT
    p.address,
    sb.stop_name,
    ROUND(ST_Distance(p.geog, sb.geog)::numeric, 2) AS distance
FROM phl.pwd_parcels p
JOIN LATERAL (
    SELECT stop_name, geog
    FROM septa.bus_stops
    ORDER BY p.geog <-> geog
    LIMIT 1
) sb ON true
ORDER BY distance DESC;
