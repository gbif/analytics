#!/bin/bash
# builds intermediate raw tables (geo and taxonomy). Update and run build_raw_script.sh first!

hive -f hive/normalize/raw_geo.q
hive -f hive/normalize/raw_taxonomy.q
