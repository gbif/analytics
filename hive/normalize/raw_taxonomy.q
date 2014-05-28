-- Use Snappy
SET hive.exec.compress.output=true;
SET mapred.output.compression.type=BLOCK;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

-- the union all means we can run in parallel
SET hive.exec.parallel=true;

CREATE TABLE snapshot.raw_taxonomy STORED AS RCFILE AS
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
    FROM raw_20071219    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20080401    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20080627    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20081010    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20081217    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20090406    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20090617    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20090925    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20091216    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20100401    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20100726    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20101117    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20110221    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20110610    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20110905    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20120118    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20120326    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20120713    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20121031   
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20121211    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20130220    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20130521    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20130709    
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
    
    UNION ALL    
    
    SELECT COALESCE(kingdom,"") AS kingdom, COALESCE(phylum,"") AS phylum, COALESCE(class_rank,"") AS class_rank, COALESCE(order_rank,"") AS order_rank, COALESCE(family,"") AS family, COALESCE(genus,"") AS genus, COALESCE(scientific_name,"") AS scientific_name, COALESCE(author,"") AS author
    FROM raw_20130910
    GROUP BY COALESCE(kingdom,""), COALESCE(phylum,""), COALESCE(class_rank,""), COALESCE(order_rank,""), COALESCE(family,""), COALESCE(genus,""), COALESCE(scientific_name,""), COALESCE(author,"")
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