#!/bin/bash -e
#
# Generate an Equal Earth map, similar to the one from Wikimedia Commons.
#

if [[ ! -e equalearth.shapes ]]; then
	psql --no-psqlrc --tuples-only --no-align -h pg1.gbif.org -U mblissett prod_eez -f generate-equalearth-map.sql > equalearth.shapes
fi

# Blank map like the Wikipedia one
cat equalearth-map.head > equalearth-blank.svg
echo '</style>' >> equalearth-blank.svg
cat equalearth.shapes >> equalearth-blank.svg
echo '</svg>' >> equalearth-blank.svg

# Template map for these analytics scripts
echo '</style>' > equalearth-map.tail
cat equalearth.shapes >> equalearth-map.tail
