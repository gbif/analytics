#!/bin/bash -e
# Copy the placeholder CSV and/or image into place for every missing CSV/chart, for each of about/figure and publishedBy/figure

set -o noclobber

# full path to dir of this script
workingdir=`dirname $0`
# report path prefix
pathprefix="report"

# Denmark will have all the CSVs:
cd $workingdir/../$pathprefix/country/DK
declare -a filelist
csvlist=(about/csv/*.csv publishedBy/csv/*.csv)
imagelist=(about/figure/*.png about/figure/*.svg publishedBy/figure/*.png publishedBy/figure/*.svg)
cd -

# for every country in report/
countries=`ls -d $pathprefix/country/* | grep -v -e XZ -e ZZ`
regions=`ls -d $pathprefix/gbifRegion/*`
for country in $countries $regions; do
	area=`echo $country | rev | cut -d/ -f 2 | rev`
	countrycode=`echo $country | rev | cut -d/ -f 1 | rev`
	# echo "$area / $countrycode"
	path=$pathprefix/$area/$countrycode
	mkdir -p $path/about/csv $path/publishedBy/csv $path/about/figure $path/publishedBy/figure

	for filename in "${csvlist[@]}"; do
		# echo "Checking $country/$filename"
		if [ ! -f $country/$filename ]; then
			# echo "Copying into $country"
			head -n 1 "$workingdir/../$pathprefix/country/DK/$filename" > $country/$filename
		fi
	done

	for filename in "${imagelist[@]}"; do
		# echo "Checking $country/$filename"
		if [ ! -f $country/$filename ]; then
			# echo "Copying into $country"
			cp -v "$workingdir"/placeholder.${filename##*.} $country/$filename
		fi
	done
done
