#!/bin/bash
# builds intermediate raw tables (geo and taxonomy). Update and run build_raw_script.sh first!

log () {
  echo $(tput setaf 6)$(date '+%Y-%m-%d %H:%M:%S ')$(tput setaf 14)$1$(tput sgr0)
}

log 'Building raw geo table'
hive -f hive/normalize/raw_geo.q
log 'Building raw taxonomy table'
hive -f hive/normalize/raw_taxonomy.q
