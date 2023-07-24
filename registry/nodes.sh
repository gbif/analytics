#!/bin/zsh
#

set -e

isoDate=$(date +%Y-%m-%d)
longDate=$(date +'%-d %B %Y')

mapSvg=registry-report/node/gbif_nodes_$isoDate.svg

title="GBIF participant nodes.  $longDate."
legend="GBIF participant nodes.  $longDate."

typeset -a nodes

# Nodes with participation status
countFile=$(mktemp)
curl -Ss 'https://api.gbif.org/v1/node?limit=500' | \
    jq -r '.results[] | select(.type=="COUNTRY") | select(.participationStatus=="VOTING" or .participationStatus=="ASSOCIATE") | "\(.country) \(.participationStatus)"' | \
    cat > $countFile

./registry/generate-country-map.sh -i "$countFile" -o "$mapSvg" -t "$title"

ln -sf $mapSvg:t registry-report/node/gbif_nodes.svg
