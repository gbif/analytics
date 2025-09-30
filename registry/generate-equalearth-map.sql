-- Map extent
SELECT '<path id="extent" class="extent" d="' ||
       ST_AsSVG(
         ST_Scale(
           ST_Transform(
             ST_GeomFromEWKT('SRID=4326;POLYGON((-180 -90, 180 -90,
                                                 180 -85, 180 -80, 180 -75, 180 -70, 180 -65, 180 -60, 180 -55, 180 -50, 180 -45, 180 -40, 180 -35, 180 -30, 180 -25, 180 -20, 180 -15, 180 -10, 180 -5, 180 0, 180 5, 180 10, 180 15, 180 20, 180 25, 180 30, 180 35, 180 40, 180 45, 180 50, 180 55, 180 60, 180 65, 180 70, 180 75, 180 80, 180 85, 180 90,
                                                 -180 90,
                                                 -180 85, -180 80, -180 75, -180 70, -180 65, -180 60, -180 55, -180 50, -180 45, -180 40, -180 35, -180 30, -180 25, -180 20, -180 15, -180 10, -180 5, -180 0, -180 -5, -180 -10, -180 -15, -180 -20, -180 -25, -180 -30, -180 -35, -180 -40, -180 -45, -180 -50, -180 -55, -180 -60, -180 -65, -180 -70, -180 -75, -180 -80, -180 -85, -180 -90))')
           , 8857)
         ,0.00001,0.00001)
       ,0,3) || '"/>';

-- Territories
-- Awkward ST_Union/GROUP BY is due to the spaceport in Kazakhstan.  Could be removed if the old_political layer is fixed to include it in Kazakhstan proper.
WITH lakes AS (
  SELECT ST_Union(geom) AS geom FROM ne_50m_lakes WHERE ST_Area(geom) >= 0.5
),
shifted AS (
  SELECT gid, iso_a2, name,
    ST_WrapX(
      ST_Translate(
        ST_Difference(p.geom, l.geom),
        -11,
        0
      ),
      -180,
      360
    ) AS geom
  FROM old_political p, lakes l
)
SELECT '<g id="' || LOWER(iso_a2) || E'">\n' ||
       '  <title>' || MIN(name) || E'</title>\n' ||
       '  <g id="' || LOWER(iso_a2) || E'-" class="landxx ' || LOWER(iso_a2) || E'">\n' ||
       '    <path id="' || MIN(gid) || '" d="' ||
         ST_AsSVG(
           ST_Scale(
             ST_Transform(
               ST_SimplifyPreserveTopology(ST_Union(geom),0.05),
               8857
             ),
             0.00001,
             0.00001
           ),
           0,
           3
         ) || E'"/>\n' ||
       E'  </g>\n' ||
       CASE WHEN iso_a2 IN ('AD', 'AG', 'AI', 'AS', 'AW', 'BB', 'BH', 'BL', 'BM', 'BQ', 'BN', 'BS', 'CC', 'CK', 'CV', 'CW', 'CX', 'CY', 'DM', 'FJ', 'FK', 'FM', 'FO', 'GD', 'GG', 'GI', 'GM', 'GP', 'GU', 'GS', 'HK', 'HM', 'IM', 'IO', 'JE', 'JM', 'KI', 'KM', 'KN', 'KW', 'KY', 'LB', 'LC', 'LI', 'LU', 'MC', 'ME', 'MF', 'MH', 'MO', 'MP', 'MQ', 'MS', 'MT', 'MU', 'MV', 'NC', 'NF', 'NR', 'NU', 'PF', 'PM', 'PN', 'PR', 'PS', 'PW', 'QA', 'RE', 'SC', 'SG', 'SH', 'SM', 'ST', 'SX', 'SZ', 'TC', 'TF', 'TK', 'TL', 'TO', 'TT', 'TV', 'VA', 'VC', 'VG', 'VI', 'VU', 'WF', 'WS', 'XK', 'YT') THEN
       '  <circle id="' || LOWER(iso_a2) || '_" class="circlexx ' || LOWER(iso_a2) || '" r="0.75" cy="' ||
         (-1*ST_Y(ST_Scale(ST_Transform(         ST_Centroid(ST_Union(geom))       ,8857),0.00001,0.00001))) || '" cx="' ||
         (   ST_X(ST_Scale(ST_Transform(        (ST_Centroid(ST_Union(geom))      ),8857),0.00001,0.00001))) || E'"/>\n' ELSE '' END ||
       '</g>' FROM shifted
       WHERE iso_a2 != 'ZZ' AND (iso_a2 NOT IN('US'))
       GROUP BY iso_a2
       ORDER BY ST_Area(ST_Union(geom)) DESC
       LIMIT 1000;

-- USA, split between both hemispheres
WITH lakes AS (
  SELECT ST_Union(geom) AS geom FROM ne_50m_lakes WHERE ST_Area(geom) >= 0.5
),
usa AS (
  SELECT
           ST_Translate(
             ST_SimplifyPreserveTopology(ST_Difference(p.geom, l.geom), 0.05),
             -11,
             0
           ) AS geom,
         iso_a2,
         name,
         gid
  FROM old_political p, lakes l
  WHERE iso_a2 IN('US'))
SELECT '<g id="' || LOWER(iso_a2) || E'">\n' ||
       '  <title>' || name || E'</title>\n' ||
       '  <path id="' || gid || 'W" class="landxx ' || LOWER(iso_a2) || '" d="' ||
         ST_AsSVG(
           ST_Scale(
             ST_Transform(
               ST_Intersection(geom, ST_MakeEnvelope(-180, -90, 0, 90, 4326)),
               8857
             ),
             0.00001,
             0.00001
           ),
           0,
           3
         ) || E'"/>\n' ||
       '  <path id="' || gid || 'E" class="landxx ' || LOWER(iso_a2) || '" d="' ||
         ST_AsSVG(
           ST_Scale(
             ST_Transform(
               ST_Intersection(geom, ST_MakeEnvelope(180, -90, 0, 90, 4326)),
               8857
             ),
             0.00001,
             0.00001
           ),
           0,
           3
         ) || E'"/>\n' ||
       '</g>' FROM usa
       LIMIT 1000;
