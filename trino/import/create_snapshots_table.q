DROP TABLE IF EXISTS snapshots;
CREATE TABLE snapshots
WITH (format = 'ORC')
AS
SELECT current_date AS snapshot, CAST(id AS BIGINT) as id, CAST(dataset_id AS varchar) AS dataset_id, CAST(publisher_id AS varchar) AS publisher_id,
    kingdom, phylum, class_rank, order_rank, family, genus, species, scientific_name, kingdom_id, phylum_id, class_id, order_id,
    family_id, genus_id, species_id, taxon_id, basis_of_record, latitude, longitude, country, day, month, year, publisher_country,
    gbif_region, publisher_gbif_region
FROM occurrence_hdfs;

