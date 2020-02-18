CREATE TABLE geology(
    uid SERIAL,
    geo_unit VARCHAR(15),
    geo_areatbms NUMERIC (10,5),
    geo_symbol SMALLINT,
    geom GEOMETRY('MULTIPOLYGON', 4686)
);

ALTER TABLE geology
ADD CONSTRAINT geology_PK PRIMARY KEY (uid);

CREATE INDEX geology_idx
ON geology
USING GIST (geom);

CREATE OR REPLACE FUNCTION calculate_new_area() RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
NEW.area = ROUND(CAST(ST_Area(ST_Transform(NEW.geom, 3116))/10000 AS NUMERIC),4);
RETURN NEW;
END
$$;

CREATE TRIGGER update_area_geology
BEFORE INSERT OR UPDATE ON geology
FOR EACH ROW
EXECUTE PROCEDURE calculate_new_area();

CREATE TABLE geology_leg(
    uid serial,
    glg_unit VARCHAR(15),
    glg_age VARCHAR 
);

ALTER TABLE geology_leg
ADD CONSTRAINT geologyleg_PK PRIMARY KEY (glg_unit);
