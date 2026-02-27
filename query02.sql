SELECT
    sb.stop_id,
    sb.stop_name,
    SUM(p.total) AS estimated_pop_800m
FROM septa.bus_stops sb
JOIN census.blockgroups_2020 bg
  ON ST_DWithin(sb.geog, bg.geog, 800)  -- 800 meters
JOIN census.population_2020 p
  ON bg.geoid = p.geoid
WHERE bg.geoid LIKE '42101%'  -- Philadelphia block groups only
GROUP BY sb.stop_id, sb.stop_name
HAVING SUM(p.total) > 500      -- only stops with population above 500
ORDER BY estimated_pop_800m ASC
LIMIT 8;
