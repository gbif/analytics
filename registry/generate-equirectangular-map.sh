#!/bin/bash -e
#
# Generate an Equirectangular map, similar to the one from Wikimedia Commons.
#

if [[ ! -e equirectangular.shapes ]]; then
	psql --no-psqlrc --tuples-only --no-align -h pg1.gbif.org -U mblissett prod_eez -f generate-equirectangular-map.sql > equirectangular.shapes
fi

# Blank map like the Wikipedia one
cat equirectangular-map.head > equirectangular-blank.svg
echo '</style>' >> equirectangular-blank.svg
echo '<rect x="-180" y="-90" width="100%" height="100%" class="extent"/>' >> equirectangular-blank.svg
cat equirectangular.shapes >> equirectangular-blank.svg
echo '</svg>' >> equirectangular-blank.svg

# Template map for these analytics scripts
echo '</style>' > equirectangular-map.tail
echo '<rect x="-180" y="-90" width="100%" height="100%" class="extent"/>' >> equirectangular-map.tail
cat equirectangular.shapes >> equirectangular-map.tail
