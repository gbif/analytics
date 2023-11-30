DROP TABLE IF EXISTS tmp_raw_taxonomy;

CREATE TABLE tmp_raw_taxonomy
WITH (format = 'ORC')
AS
SELECT
  CONCAT_WS('|',
    t1.kingdom,
    t1.phylum,
    t1.class_rank,
    t1.order_rank,
    t1.family,
    t1.genus,
    t1.scientific_name,
    t1.specific_epithet,
    t1.infra_specific_epithet,
    t1.author,
    t1.rank
  ) AS taxon_key,
  t1.kingdom,
  t1.phylum,
  t1.class_rank,
  t1.order_rank,
  t1.family,
  t1.genus,
  t1.scientific_name,
  t1.specific_epithet,
  t1.infra_specific_epithet,
  t1.author,
  t1.rank
FROM
(
 SELECT COALESCE(v_kingdom,'') AS kingdom, COALESCE(v_phylum,'') AS phylum, COALESCE(v_class,'') AS class_rank, COALESCE(v_order,'') AS order_rank, COALESCE(v_family,'') AS family, COALESCE(v_genus,'') AS genus, COALESCE(v_scientificname,'') AS scientific_name, COALESCE(v_specificepithet,'') AS specific_epithet, COALESCE(v_infraspecificepithet,'') AS infra_specific_epithet, COALESCE(v_scientificnameauthorship,'') AS author, COALESCE(v_taxonrank,'') AS rank
    FROM raw
    GROUP BY COALESCE(v_kingdom,''), COALESCE(v_phylum,''), COALESCE(v_class,''), COALESCE(v_order,''), COALESCE(v_family,''), COALESCE(v_genus,''), COALESCE(v_scientificname,''), COALESCE(v_scientificnameauthorship,''), COALESCE(v_specificepithet,''), COALESCE(v_infraspecificepithet,''), COALESCE(v_taxonrank,'')
) t1
  GROUP BY
    t1.kingdom,
    t1.phylum,
    t1.class_rank,
    t1.order_rank,
    t1.family,
    t1.genus,
    t1.scientific_name,
    t1.specific_epithet,
    t1.infra_specific_epithet,
    t1.author,
    t1.rank
ORDER BY rand();

