-- occ_country_complete
DROP TABLE IF EXISTS occ_country_complete;
CREATE TABLE occ_country_complete
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) AS snapshot,
  country,
  basis_of_record,
  CAST(COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS rank,
  CAST(COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS geospatial,
  CAST(COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS temporal,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
GROUP BY
  snapshot,
  country,
  basis_of_record,
  COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    'Unknown'
  ),
  COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    'Unknown'
  ),
  COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    'Unknown'
  );

-- occ_publisherCountry_complete
DROP TABLE IF EXISTS occ_publisherCountry_complete;
CREATE TABLE occ_publisherCountry_complete
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) AS snapshot,
  publisher_country,
  basis_of_record,
  CAST(COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS rank,
  CAST(COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS geospatial,
  CAST(COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS temporal,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
GROUP BY
  snapshot,
  publisher_country,
  basis_of_record,
  COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    'Unknown'
  ),
  COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    'Unknown'
  ),
  COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    'Unknown'
  );

-- occ_gbifRegion_complete
DROP TABLE IF EXISTS occ_gbifRegion_complete;
CREATE TABLE occ_gbifRegion_complete
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) AS snapshot,
  gbif_region,
  basis_of_record,
  CAST(COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS rank,
  CAST(COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS geospatial,
  CAST(COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS temporal,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
GROUP BY
  snapshot,
  gbif_region,
  basis_of_record,
  COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    'Unknown'
  ),
  COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    'Unknown'
  ),
  COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    'Unknown'
  );

-- occ_publisherGbifRegion_complete
DROP TABLE IF EXISTS occ_publisherGbifRegion_complete;
CREATE TABLE occ_publisherGbifRegion_complete
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) AS snapshot,
  publisher_gbif_region,
  basis_of_record,
  CAST(COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS rank,
  CAST(COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS geospatial,
  CAST(COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS temporal,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
GROUP BY
  snapshot,
  publisher_gbif_region,
  basis_of_record,
  COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    'Unknown'
  ),
  COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    'Unknown'
  ),
  COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    'Unknown'
  );

-- occ_complete
DROP TABLE IF EXISTS occ_complete;
CREATE TABLE occ_complete
WITH (format = 'CSV')
AS SELECT
  CAST(snapshot AS varchar) AS snapshot,
  basis_of_record,
  CAST(COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS rank,
  CAST(COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS geospatial,
  CAST(COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    'Unknown'
  ) AS varchar) AS temporal,
  CAST(COUNT(*) AS varchar) AS count
FROM snapshots
GROUP BY
  snapshot,
  basis_of_record,
  COALESCE(
    CASE WHEN species_id IS NOT NULL AND species_id != taxon_id THEN 'Infraspecies' ELSE NULL END,
    CASE WHEN species_id IS NOT NULL THEN 'Species' ELSE NULL END,
    CASE WHEN genus_id IS NOT NULL THEN 'Genus' ELSE NULL END,
    CASE WHEN family_id IS NOT NULL THEN 'Family' ELSE NULL END,
    CASE WHEN order_id IS NOT NULL THEN 'Order' ELSE NULL END,
    CASE WHEN class_id IS NOT NULL THEN 'Class' ELSE NULL END,
    CASE WHEN phylum_id IS NOT NULL THEN 'Phylum' ELSE NULL END,
    CASE WHEN kingdom_id IS NOT NULL AND kingdom_id != 0 THEN 'Kingdom' ELSE NULL END,
    'Unknown'
  ),
  COALESCE(
    CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 'Georeferenced' ELSE NULL END,
    CASE WHEN country IS NOT NULL THEN 'CountryOnly' ELSE NULL END,
    'Unknown'
  ),
  COALESCE(
    CASE WHEN year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL THEN 'YearMonthDay' ELSE NULL END,
    CASE WHEN year IS NOT NULL AND month IS NOT NULL THEN 'YearMonth' ELSE NULL END,
    CASE WHEN year IS NOT NULL THEN 'YearOnly' ELSE NULL END,
    'Unknown'
  );
