#!/bin/bash
# builds intermediate raw tables (geo and taxonomy). Update and run build_raw_script.sh first!

hive -f raw_geo.q
hive -f raw_taxonomy.q