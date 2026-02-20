/*

This file contains the SQL commands to prepare the database for your queries.
Before running this file, you should have created your database, created the
schemas (see below), and loaded your data into the database.

Creating your schemas
---------------------

You can create your schemas by running the following statements in PG Admin:

    create schema if not exists septa;
    create schema if not exists phl;
    create schema if not exists census;

Also, don't forget to enable PostGIS on your database:

    create extension if not exists postgis;

Loading your data
-----------------

After you've created the schemas, load your data into the database specified in
the assignment README.

Finally, you can run this file either by copying it all into PG Admin, or by
running the following command from the command line:

    psql -U postgres -d <YOUR_DATABASE_NAME> -f db_structure.sql

*/



CREATE TABLE septa.bus_stops (
    stop_id TEXT,
    stop_name TEXT,
    stop_lat DOUBLE PRECISION,
    stop_lon DOUBLE PRECISION,
    location_type INTEGER,
    parent_station TEXT,
    zone_id TEXT,
    wheelchair_boarding INTEGER
);





CREATE TABLE septa.bus_routes (
    route_id TEXT,
    agency_id TEXT,
    route_short_name TEXT,
    route_long_name TEXT,
    route_desc TEXT,
    route_type TEXT,
    route_url TEXT,
    route_color TEXT,
    route_text_color TEXT
);

CREATE TABLE septa.bus_trips (
    route_id TEXT,
    service_id TEXT,
    trip_id TEXT,
    trip_headsign TEXT,
    trip_short_name TEXT,
    direction_id TEXT,
    block_id TEXT,
    shape_id TEXT,
    wheelchair_accessible INTEGER,
    bikes_allowed INTEGER
);

CREATE TABLE septa.bus_shapes (
    shape_id TEXT,
    shape_pt_lat DOUBLE PRECISION,
    shape_pt_lon DOUBLE PRECISION,
    shape_pt_sequence INTEGER,
    shape_dist_traveled DOUBLE PRECISION
);

CREATE TABLE septa.rail_stops (
    stop_id TEXT,
    stop_name TEXT,
    stop_desc TEXT,
    stop_lat DOUBLE PRECISION,
    stop_lon DOUBLE PRECISION,
;    zone_id TEXT,
    stop_url TEXT
);

ogr2ogr \
    -f "PostgreSQL" \
    PG:"host=localhost port=5432 dbname=assignment2 user=postgres password=postgres" \
    -nln census.blockgroups_2020 \
    -nlt MULTIPOLYGON \
    -t_srs EPSG:4326 \
    -lco GEOMETRY_NAME=geog \
    -lco GEOM_TYPE=GEOGRAPHY \
    -overwrite \
    "C:\Users\kalmanj\Documents\SCHOOL\cloudcomputing\assignment1\assignment02\tl_2020_42_bg.shp"


-- Drop the old table if it exists
DROP TABLE IF EXISTS census.population_2020;

-- Create a fresh population table
CREATE TABLE census.population_2020 (
    geoid TEXT PRIMARY KEY,
    geoname TEXT,
    total INTEGER
);
-- Insert data directly from blockgroups_2020




CREATE EXTENSION IF NOT EXISTS postgis;
SELECT PostGIS_Version();


SET search_path = public, "$user", public;

ogr2ogr -f "PostgreSQL" PG:"host=localhost port=5432 dbname=assignment2 user=postgres password=postgres" -nln census.pop_raw -lco GEOMETRY_NAME=geog -lco GEOM_TYPE=GEOGRAPHY -overwrite "C:\Users\kalmanj\Documents\SCHOOL\cloudcomputing\assignment1\assignment02\DECENNIALPL2020.P1-Data.csv" -oo GEOM_POSSIBLE_NAMES=geom -oo X_POSSIBLE_NAMES=lon -oo Y_POSSIBLE_NAMES=lat


DROP TABLE IF EXISTS census.population_2020;

DROP TABLE IF EXISTS census.population_2020;

CREATE TABLE census.population_2020 AS
SELECT
    bg.geoid,
    bg.namelsad,
    r.p1_001n AS total
FROM census.blockgroups_2020 bg
JOIN census.pop_raw r
  ON bg.geog = r.geo_id;

SELECT geo_id FROM census.pop_raw LIMIT 5;

ALTER TABLE census.pop_raw
ADD COLUMN IF NOT EXISTS geoid_clean TEXT;

UPDATE census.pop_raw
SET geoid_clean = RIGHT(geo_id, 12);

DROP TABLE IF EXISTS census.population_2020;

CREATE TABLE census.population_2020 AS
SELECT
    bg.geoid,
    bg.namelsad,
    r.p1_001n AS total
FROM census.blockgroups_2020 bg
JOIN census.pop_raw r
  ON bg.geoid = r.geoid_clean;


CREATE INDEX IF NOT EXISTS idx_parcels_geog
ON phl.pwd_parcels USING GIST(geog);

CREATE INDEX IF NOT EXISTS idx_stops_geog
ON septa.bus_stops USING GIST(geog);
