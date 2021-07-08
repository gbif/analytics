#!/bin/zsh -e
#
# Generate a map of active publishing organizations (those publishing at least one dataset, of any type).
#
# Colour the map according to the number of such organizations in each country, area or island.
#
# NOTE:
# The data could also come from the analytics, but only for occurrences.  That would allow a time lapse.
#
# The map source is "BlankMap-World.svg" from Wikimedia Commons, which is in the public domain.  This map
# may as well be in the public domain too.  Check the file history in case there are updates.
# https://commons.wikimedia.org/wiki/File:BlankMap-World.svg
#

isoDate=$(date +%Y-%m-%d)
longDate=$(date +'%-d %B %Y')

mapSvg=registry-report/organization/active_gbif_publishing_organizations_by_country_$isoDate.svg
mapData=registry-report/organization/active_gbif_publishing_organizations_$isoDate.tsv

sed "s/World Map/Active GBIF data publishing organizations by country or area.  $longDate./" < ${0:a:h}/robinson-map.head > $mapSvg
echo >> $mapSvg
echo "/* Begin calculated styles */" >> $mapSvg
echo >> $mapSvg

typeset -a publishing

# All publishing organizations with at least one dataset
if [[ $(curl -Ss 'https://api.gbif.org/v1/dataset/search?limit=0&facet=publishingOrg&facetLimit=50000' | jq -r '.facets[0].counts | length') -ge 50000 ]]; then
	echo "Too many publishing organizations"
	exit 1
fi
publishing=($(curl -Ss 'https://api.gbif.org/v1/dataset/search?limit=0&facet=publishingOrg&facetLimit=50000' | jq -r '.facets[0].counts[].name'))

# We are counting the number of organizations publishing at least one dataset per country.
typeset -A publishingOrganizationsPerCountry

echo -e "publishing_organization_key\tpublishing_country" > $mapData
for p in $publishing; do
	c=$(curl -Ss http://api.gbif.org/v1/organization/$p | jq -r '.country')
	echo -e "$p\t$c" | sed 's/null//' >> $mapData
	publishingOrganizationsPerCountry[$c]=$(($publishingOrganizationsPerCountry[$c] + 1))
done

#for country total in $(cat data); do
#	publishingOrganizationsPerCountry[$country]=$total
#done

for country total in ${(kv)publishingOrganizationsPerCountry}; do

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

	echo "/* $country has $total publishing organizations */" >> $mapSvg
	echo "path#${country:l}, g#${country:l} > path, g#${country:l} > circle, g#${country:l}- > path { fill: $colour; opacity: 1; }" >> $mapSvg
done

echo "/* Countries with zero data-publishing organizations */" >> $mapSvg
for country in $(curl -Ss https://api.gbif.org/v1/enumeration/country | jq -r '.[].iso2'); do
	if [[ -z "$publishingOrganizationsPerCountry[$country]" ]]; then
		echo Country $country "$publishingOrganizationsPerCountry[$country]" "publishes nothing"
		echo "path#${country:l}, g#${country:l} > path, g#${country:l} > circle, g#${country:l}- > path { fill: #c0c0c0; }" >> $mapSvg
		echo "g#${country:l} > circle { opacity: 0; }" >> $mapSvg
	fi
done

echo >> $mapSvg
echo "/* End calculated styles */" >> $mapSvg
echo >> $mapSvg

sed "s/Number of active publishers by country or area/Number of active publishers by country or area.  $longDate./" < ${0:a:h}/robinson-map.tail >> $mapSvg

ln -sf $mapSvg:t registry-report/organization/active_gbif_publishing_organizations_by_country.svg
ln -sf $mapData:t registry-report/organization/active_gbif_publishing_organizations.tsv
