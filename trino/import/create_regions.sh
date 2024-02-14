rm -f analytics_regions.tsv

(
	curl -Ssg https://api.gbif.org/v1/enumeration/country | jq -r '.[] | "\(.iso2);\(.gbifRegion)"'
	# Kosovo's code isn't shown in that enumeration
	echo -e "XK\tEUROPE"
	# Snapshots 2010-04-01 and 2010-07-26 contain UK values.
	echo -e "UK\tEUROPE"
) | sort | sort -k2 > analytics_regions.csv
