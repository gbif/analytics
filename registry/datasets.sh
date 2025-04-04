#!/bin/bash -e
#
# Store a registry download of all datasets
#

curl -Ss --fail 'https://api.gbif.org/v1/dataset/search/export?format=TSV' > /data/analytics/registry/registry-report/dataset/datasets_$(date +%Y-%m-%d).tsv

ln -sf datasets_$(date +%Y-%m-%d).tsv /data/analytics/registry/registry-report/dataset/datasets.tsv
