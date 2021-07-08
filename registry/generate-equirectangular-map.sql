-- Territories
-- Awkward ST_Union/GROUP BY is due to the spaceport in Kazakhstan.  Could be removed if the political layer is fixed to include it in Kazakhstan proper.
SELECT '<g id="' || LOWER(iso_a2) || '">\n' ||
       '<title>' || MIN(name) || '</title>\n' ||
       '<path id="' || MIN(gid) || '" class="landxx ' || LOWER(iso_a2) || '" d="' || ST_AsSVG(ST_SimplifyPreserveTopology(ST_Union(geom),0.1),0,3) || '"/>' ||
       CASE WHEN iso_a2 IN ('AD', 'AG', 'AI', 'AS', 'AW', 'BB', 'BH', 'BL', 'BM', 'BN', 'BS', 'CK', 'CV', 'CW', 'CY', 'DM', 'FJ', 'FK', 'FM', 'FO', 'GD', 'GG', 'GI', 'GM', 'GU', 'IM', 'JE', 'JM', 'KI', 'KM', 'KN', 'KW', 'KY', 'LB', 'LC', 'LI', 'LU', 'MC', 'ME', 'MF', 'MH', 'MP', 'MS', 'MT', 'MU', 'MV', 'NC', 'NR', 'NU', 'PF', 'PM', 'PN', 'PR', 'PS', 'PW', 'QA', 'SC', 'SG', 'SH', 'SM', 'ST', 'SX', 'SZ', 'TC', 'TK', 'TL', 'TO', 'TT', 'TV', 'VA', 'VC', 'VG', 'VI', 'VU', 'WF', 'WS') THEN
       '<circle id="' || LOWER(iso_a2) || '_" class="circlexx ' || LOWER(iso_a2) || '" r="0.75" cy="' || (-1*ST_Y(ST_Centroid(ST_Union(geom)))) || '" cx="' || ST_X(ST_Centroid(ST_Union(geom))) || '"/>' ELSE '' END ||
       '</g>' FROM political
       WHERE iso_a2 != 'ZZ' AND (iso_a2 != 'CY' OR iso_a3 = 'CYP')
       GROUP BY iso_a2;

-- Circles
SELECT '<g id="' || LOWER(iso_a2) || '">\n' ||
       '<title>' || name || '</title>\n' ||
       '<path id="' || gid || '" class="landxx ' || LOWER(iso_a2) || '" d="' || ST_AsSVG(ST_SimplifyPreserveTopology(geom,0.025),0,3) || '"/>' ||
       '<circle id="' || LOWER(iso_a2) || '_" class="circlexx ' || LOWER(iso_a2) || '" r="0.75" cy="' || (-1*ST_Y(ST_Centroid(geom))) || '" cx="' || ST_X(ST_Centroid(geom)) || '"/>' ||
       '</g>' FROM political
       WHERE iso_a2 IN ('AD', 'AG', 'AI', 'AS', 'AW', 'BB', 'BH', 'BL', 'BM', 'BN', 'BS', 'CK', 'CV', 'CW', 'CY', 'DM', 'FJ', 'FK', 'FM', 'FO', 'GD', 'GG', 'GI', 'GM', 'GU', 'IM', 'JE', 'JM', 'KI', 'KM', 'KN', 'KW', 'KY', 'LB', 'LC', 'LI', 'LU', 'MC', 'ME', 'MF', 'MH', 'MP', 'MS', 'MT', 'MU', 'MV', 'NC', 'NR', 'NU', 'PF', 'PM', 'PN', 'PR', 'PS', 'PW', 'QA', 'SC', 'SG', 'SH', 'SM', 'ST', 'SX', 'SZ', 'TC', 'TK', 'TL', 'TO', 'TT', 'TV', 'VA', 'VC', 'VG', 'VI', 'VU', 'WF', 'WS')
       AND (iso_a2 != 'CY' OR iso_a3 = 'CYP');

-- Small circles
SELECT '<g id="' || LOWER(iso_a2) || '">\n' ||
       '<title>' || name || '</title>\n' ||
       '<path id="' || gid || '" class="landxx ' || LOWER(iso_a2) || '" d="' || ST_AsSVG(ST_SimplifyPreserveTopology(geom,0.025),0,3) || '"/>' ||
       '<circle id="' || LOWER(iso_a2) || '_" class="circlexx ' || LOWER(iso_a2) || '" r="0.75" cy="' || (-1*ST_Y(ST_Centroid(geom))) || '" cx="' || ST_X(ST_Centroid(geom)) || '"/>' ||
       '</g>' FROM political
       WHERE iso_a2 IN ('BQ', 'CC', 'CX', 'GP', 'GS', 'HK', 'HM', 'IO', 'MO', 'MQ', 'NF', 'RE', 'TF', 'XK', 'YT');
