#!/bin/zsh
#

set -e

isoDate=$(date +%Y-%m-%d)
longDate=$(date +'%-d %B %Y')

robMapSvg=/data/analytics/registry/registry-report/node/gbif_nodes_robinson_$isoDate.svg
eqaMapSvg=/data/analytics/registry/registry-report/node/gbif_nodes_$isoDate.svg

title="GBIF participant nodes.  $longDate."
legend="GBIF participant nodes.  $longDate."

typeset -a nodes

# Nodes with participation status
countFile=$(mktemp)
curl -Ss 'https://api.gbif.org/v1/node?limit=500' | \
    jq -r '.results[] | select(.type=="COUNTRY") | select(.participationStatus=="VOTING" or .participationStatus=="ASSOCIATE") | "\(.country) \(.participationStatus)"' | \
    cat > $countFile

./registry/generate-country-map.sh -p "robinson"   -i "$countFile" -o "$robMapSvg" -t "$title"
./registry/generate-country-map.sh -p "equalearth" -i "$countFile" -o "$eqaMapSvg" -t "$title"

ln -sf $eqaMapSvg:t /data/analytics/registry/registry-report/node/gbif_nodes.svg
