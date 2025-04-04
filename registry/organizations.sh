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

mapSvg=/data/analytics/registry/registry-report/organization/active_gbif_publishing_organizations_by_country_$isoDate.svg
mapData=/data/analytics/registry/registry-report/organization/active_gbif_publishing_organizations_$isoDate.tsv

title="Active GBIF data publishing organizations by country or area.  $longDate."
legend="Number of active publishers by country or area.  $longDate."

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

countFile=$(mktemp)
for country total in ${(kv)publishingOrganizationsPerCountry}; do
    echo "$country	$total" >> $countFile
done

./registry/generate-country-map.sh -i "$countFile" -o "$mapSvg" -t "$title" -l "$legend"

ln -sf $mapSvg:t /data/analytics/registry/registry-report/organization/active_gbif_publishing_organizations_by_country.svg
ln -sf $mapData:t /data/analytics/registry/registry-report/organization/active_gbif_publishing_organizations.tsv

# Report new countries
echo "Newly publishing countries (check if any small areas will need highlighting)"
if ! diff \
    <(curl -Ss https://analytics-files.gbif.org/registry/organization/active_gbif_publishing_organizations.tsv | cut -d $'\t' -f 2 | sort -u) \
    <(cat /data/analytics/registry/registry-report/organization/active_gbif_publishing_organizations.tsv | cut -d $'\t' -f 2 | sort -u) \
    > registry-report-new-countries; then
    #cat registry-report-new-countries | mail -s "Newly publishing countries, check if any are small and will need special highlighting" mblissett@gbif.org
fi
