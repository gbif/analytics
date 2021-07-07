#!/bin/zsh -e
#
# Generate a map of active publishing institutions (those publishing at least one dataset, of any type).
#
# Colour the map according to the number of such institutions in each country, area or island.
#
# NOTE:
# The data could also come from the analytics, but only for occurrences.  That would allow a time lapse.
#

out=active_gbif_publishing_institutions_by_country_$(date +%Y-%m-%d).svg

sed "s/World Map/Active GBIF data publishing institutions by country, area or island/" < robinson-map.head > $out
echo >> $out
echo "/* Begin calculated styles */" >> $out
echo >> $out

typeset -a publishing

# All publishing organizations with at least one dataset
if [[ $(curl -Ss 'https://api.gbif.org/v1/dataset/search?limit=0&facet=publishingOrg&facetLimit=50000' | jq -r '.facets[0].counts | length') -ge 50000 ]]; then
	echo "Too many publishing organizations"
	exit 1
fi
publishing=($(curl -Ss 'https://api.gbif.org/v1/dataset/search?limit=0&facet=publishingOrg&facetLimit=50000' | jq -r '.facets[0].counts[].name'))

# We are counting the number of institutions publishing at least one dataset per country.
typeset -A publishingInstitutionsPerCountry

for p in $publishing; do
	c=$(curl -Ss http://api.gbif.org/v1/organization/$p | jq -r '.country')
	echo "Publisher $p in $c"
	publishingInstitutionsPerCountry[$c]=$(($publishingInstitutionsPerCountry[$c] + 1))
done

#for country total in $(cat data); do
#	publishingInstitutionsPerCountry[$country]=$total
#done

for country total in ${(kv)publishingInstitutionsPerCountry}; do

	if [[ $total -ge 100 ]]; then
		colour='#2f4858'
    elif [[ $total -ge 40 ]]; then
		colour='#1d5969'
    elif [[ $total -ge 10 ]]; then
		colour='#006b72'
    elif [[ $total -ge 4 ]]; then
		colour='#007c71'
    elif [[ $total -ge 2 ]]; then
		colour='#258c66'
    else
		colour='#559a55'
	fi

	echo "/* $country has $total publishing institutions */" >> $out
	echo "path#${country:l}, g#${country:l} > path, g#${country:l} > circle, g#${country:l}- > path { fill: $colour; opacity: 1; }" >> $out
done

echo "/* Countries with zero data-publishing institutions */" >> $out
for country in $(curl -Ss https://api.gbif.org/v1/enumeration/country | jq -r '.[].iso2'); do
	if [[ -z "$publishingInstitutionsPerCountry[$country]" ]]; then
		echo Country $country "$publishingInstitutionsPerCountry[$country]" "publishes nothing"
		echo "path#${country:l}, g#${country:l} > path, g#${country:l} > circle, g#${country:l}- > path { fill: #c0c0c0; }" >> $out
		echo "g#${country:l} > circle { opacity: 0; }" >> $out
	fi
done

echo >> $out
echo "/* End calculated styles */" >> $out
echo >> $out

cat robinson-map.tail >> $out
