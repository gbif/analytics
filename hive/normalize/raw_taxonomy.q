
-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compression.type=BLOCK;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

-- the union all means we can run in parallel
SET hive.exec.parallel=true;

DROP TABLE IF EXISTS snapshot.tmp_raw_taxonomy;
CREATE TABLE snapshot.tmp_raw_taxonomy STORED AS RCFILE AS
SELECT
  CONCAT_WS("|", 
    t1.kingdom, 
    t1.phylum, 
    t1.class_rank,
    t1.order_rank,
    t1.family,
    t1.genus,
    t1.scientific_name,
    t1.author
  ) AS taxon_key,
  t1.kingdom, 
  t1.phylum, 
  t1.class_rank, 
  t1.order_rank, 
  t1.family, 
  t1.genus, 
  t1.scientific_name, 
  t1.author
FROM 
  (

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20071219
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20080401
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20080627
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20081010
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20081217
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20090406
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20090617
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20090925
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20091216
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20100401
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20100726
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20101117
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20110221
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20110610
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20110905
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20120118
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20120326
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20120713
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20121031
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20121211
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20130220
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20130521
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20130709
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20130910
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20131220
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM snapshot.raw_20140328
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL

    SELECT COALESCE(v_kingdom,"") AS kingdom, COALESCE(v_phylum,"") AS phylum, COALESCE(v_class,"") AS class_rank, COALESCE(v_order_,"") AS order_rank, COALESCE(v_family,"") AS family, COALESCE(v_genus,"") AS genus, COALESCE(v_scientificname,"") AS scientific_name, COALESCE(v_scientificnameauthorship,"") AS author
    FROM snapshot.raw_20140908
    GROUP BY COALESCE(v_kingdom,""), COALESCE(v_phylum,""), COALESCE(v_class,""), COALESCE(v_order_,""), COALESCE(v_family,""), COALESCE(v_genus,""), COALESCE(v_scientificname,""), COALESCE(v_scientificnameauthorship,"")
    
    UNION ALL

    SELECT COALESCE(v_kingdom,"") AS kingdom, COALESCE(v_phylum,"") AS phylum, COALESCE(v_class,"") AS class_rank, COALESCE(v_order_,"") AS order_rank, COALESCE(v_family,"") AS family, COALESCE(v_genus,"") AS genus, COALESCE(v_scientificname,"") AS scientific_name, COALESCE(v_scientificnameauthorship,"") AS author
    FROM snapshot.raw_20150119
    GROUP BY COALESCE(v_kingdom,""), COALESCE(v_phylum,""), COALESCE(v_class,""), COALESCE(v_order_,""), COALESCE(v_family,""), COALESCE(v_genus,""), COALESCE(v_scientificname,""), COALESCE(v_scientificnameauthorship,"")
    
    UNION ALL

    SELECT COALESCE(v_kingdom,"") AS kingdom, COALESCE(v_phylum,"") AS phylum, COALESCE(v_class,"") AS class_rank, COALESCE(v_order_,"") AS order_rank, COALESCE(v_family,"") AS family, COALESCE(v_genus,"") AS genus, COALESCE(v_scientificname,"") AS scientific_name, COALESCE(v_scientificnameauthorship,"") AS author
    FROM snapshot.raw_20150409
    GROUP BY COALESCE(v_kingdom,""), COALESCE(v_phylum,""), COALESCE(v_class,""), COALESCE(v_order_,""), COALESCE(v_family,""), COALESCE(v_genus,""), COALESCE(v_scientificname,""), COALESCE(v_scientificnameauthorship,"")
    
    UNION ALL

    SELECT COALESCE(v_kingdom,"") AS kingdom, COALESCE(v_phylum,"") AS phylum, COALESCE(v_class,"") AS class_rank, COALESCE(v_order,"") AS order_rank, COALESCE(v_family,"") AS family, COALESCE(v_genus,"") AS genus, COALESCE(v_scientificname,"") AS scientific_name, COALESCE(v_scientificnameauthorship,"") AS author
    FROM snapshot.raw_20150703
    GROUP BY COALESCE(v_kingdom,""), COALESCE(v_phylum,""), COALESCE(v_class,""), COALESCE(v_order,""), COALESCE(v_family,""), COALESCE(v_genus,""), COALESCE(v_scientificname,""), COALESCE(v_scientificnameauthorship,"")
UNION ALL

    SELECT COALESCE(v_kingdom,"") AS kingdom, COALESCE(v_phylum,"") AS phylum, COALESCE(v_class,"") AS class_rank, COALESCE(v_order,"") AS order_rank, COALESCE(v_family,"") AS family, COALESCE(v_genus,"") AS genus, COALESCE(v_scientificname,"") AS scientific_name, COALESCE(v_scientificnameauthorship,"") AS author
    FROM snapshot.raw_20151001
    GROUP BY COALESCE(v_kingdom,""), COALESCE(v_phylum,""), COALESCE(v_class,""), COALESCE(v_order,""), COALESCE(v_family,""), COALESCE(v_genus,""), COALESCE(v_scientificname,""), COALESCE(v_scientificnameauthorship,"")
UNION ALL

    SELECT COALESCE(v_kingdom,"") AS kingdom, COALESCE(v_phylum,"") AS phylum, COALESCE(v_class,"") AS class_rank, COALESCE(v_order,"") AS order_rank, COALESCE(v_family,"") AS family, COALESCE(v_genus,"") AS genus, COALESCE(v_scientificname,"") AS scientific_name, COALESCE(v_scientificnameauthorship,"") AS author
    FROM snapshot.raw_20160104
    GROUP BY COALESCE(v_kingdom,""), COALESCE(v_phylum,""), COALESCE(v_class,""), COALESCE(v_order,""), COALESCE(v_family,""), COALESCE(v_genus,""), COALESCE(v_scientificname,""), COALESCE(v_scientificnameauthorship,"")

) t1
GROUP BY
  t1.kingdom, 
  t1.phylum,
  t1.class_rank,
  t1.order_rank,
  t1.family, 
  t1.genus, 
  t1.scientific_name,
  t1.author;
