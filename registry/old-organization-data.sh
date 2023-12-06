#!/bin/zsh -e
# Generate organization data (as close as we can) for before we started querying the registry on the day of the analytics.

# Snapshots for which organization statistics were taken at the time
declare -a newer_snapshots=("2021-07-01" "2021-10-01" "2022-01-01" "2022-04-01" "2022-07-01" "2022-10-01" "2023-01-01" "2023-04-01" "2023-07-01")

declare -a snapshots=("2013-12-20" "2014-03-28" "2014-09-08" "2015-01-19" "2015-04-09" "2015-07-03" "2015-10-01" "2016-01-04" "2016-04-05" "2016-07-04" "2016-10-07" "2016-12-27" "2017-04-12" "2017-07-24" "2017-10-12" "2017-12-22" "2018-04-09" "2018-07-11" "2018-09-28" "2019-01-01" "2019-04-06" "2019-07-01" "2019-10-09" "2020-01-01" "2020-04-01" "2020-07-01" "2020-10-01" "2021-01-01" "2021-04-01")

declare -a pre_registry_snapshots=("2007-12-19" "2008-04-01" "2008-06-27" "2008-10-10" "2008-12-17" "2009-04-06" "2009-06-17" "2009-09-25" "2009-12-16" "2010-04-01" "2010-07-26" "2010-11-17" "2011-02-21" "2011-06-10" "2011-09-05" "2012-01-18" "2012-03-26" "2012-07-13" "2012-10-31" "2012-12-11" "2013-02-20" "2013-05-21" "2013-07-09" "2013-09-10")

# Although this works, the snapshot data seems to be less accurate than the Registry.
# There are several null values in publisher_????????.iso_country_code, which have since been added
# in the Registry.
# for s in $pre_registry_snapshots; do
#     isoDate=$(date +%Y-%m-%d -d $s)
#     longDate=$(date +'%-d %B %Y' -d $s)

#     mapSvg=registry-report/organization/active_gbif_publishing_organizations_by_country_$isoDate.svg
#     mapData=registry-report/organization/active_gbif_publishing_organizations_$isoDate.tsv
#     mapSvg=x_active_gbif_publishing_organizations_by_country_$isoDate.svg
#     mapData=x_active_gbif_publishing_organizations_$isoDate.tsv

#     title="Active GBIF data publishing organizations by country or area.  $longDate."
#     legend="Number of active publishers by country or area.  $longDate."

#     shortDate=$(date +%Y%m%d -d $s)
#     echo -e "publishing_organization_key\tpublishing_country" > $mapData
#     echo "SELECT p.id, p.iso_country_code FROM snapshot.publisher_$shortDate p, snapshot.dataset_$shortDate d where p.id = d.data_provider_id GROUP BY p.id, p.iso_country_code;" | \
#         ssh mblissett@c5gateway-vh.gbif.org hive | grep -v -e SELECT -e WARN >> $mapData

#     countFile=$(mktemp)
#     echo "SELECT p.iso_country_code, COUNT(DISTINCT p.id) FROM snapshot.publisher_$shortDate p, snapshot.dataset_$shortDate d where p.id = d.data_provider_id GROUP BY p.iso_country_code;" | \
#         ssh mblissett@c5gateway-vh.gbif.org hive | grep -v -e SELECT -e WARN > $countFile

#     ./generate-country-map.sh -i "$countFile" -o "$mapSvg" -t "$title" -l "$legend"
# done

for s in $pre_registry_snapshots $snapshots; do

    isoDate=$(date +%Y-%m-%d -d $s)
    longDate=$(date +'%-d %B %Y' -d $s)

    mapSvg=registry-report/organization/active_gbif_publishing_organizations_by_country_$isoDate.svg
    mapData=registry-report/organization/active_gbif_publishing_organizations_$isoDate.tsv
    mapSvg=active_gbif_publishing_organizations_by_country_$isoDate.svg
    mapData=active_gbif_publishing_organizations_$isoDate.tsv

    title="Active GBIF data publishing organizations by country or area.  $longDate."
    legend="Number of active publishers by country or area.  $longDate."

    # o.created <= '$isoDate' could be included, which would avoid the case of counting a dataset
    # older than its organization.  (That can happen when a dataset is moved to a new organization).
    echo -e "publishing_organization_key\tpublishing_country" > $mapData
    psql -X -t -A -F$'\t' -h pg1.gbif.org -U registry prod_b_registry -c "SELECT DISTINCT o.key, o.country FROM dataset d, organization o WHERE d.publishing_organization_key = o.key AND d.created <= '$isoDate' AND (d.deleted IS NULL OR d.deleted > '$isoDate');" >> $mapData

    countFile=$(mktemp)
    psql -X -t -A -F$'\t' -h pg1.gbif.org -U registry prod_b_registry -c "SELECT o.country, COUNT(DISTINCT o.key) FROM dataset d, organization o WHERE d.publishing_organization_key = o.key AND d.created <= '$isoDate' AND (d.deleted IS NULL OR d.deleted > '$isoDate') AND o.country IS NOT NULL GROUP BY o.country;" > $countFile

    ./generate-country-map.sh -i "$countFile" -o "$mapSvg" -t "$title" -l "$legend"
done
