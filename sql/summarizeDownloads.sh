#!/bin/bash -e

for i in sql/*.sql; do
	psql --no-psqlrc --no-align --field-separator=, --host pg1.gbif.org --username registry prod_b_registry --file $i | \
		grep -v -e ^SET -e 'rows)' > $1/$(basename $i .sql).csv
done
