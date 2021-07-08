#!/bin/bash -e
#
# Generate an Equirectangular map, similar to the one from Wikimedia Commons.
#

cat equirectangular.head

if [[ -e equirectangular.shapes ]]; then
	cat equirectangular.shapes
else
	psql -h pg1.gbif.org -U mblissett prod_eez -f generate-equirectangular-map.sql | tee equirectangular.shapes
fi

cat equirectangular.tail
