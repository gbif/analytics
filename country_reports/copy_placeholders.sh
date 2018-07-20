#!/bin/bash -e
# Copy the placeholder image into place for every missing chart, for each of about/figure and publishedBy/figure

# full path to dir of this script
workingdir=`dirname $0`
# report path prefix
pathprefix="report"

# Denmark will have all the figures:
cd $workingdir/../$pathprefix/country/DK
declare -a filelist
filelist=(about/figure/*.png about/figure/*.svg publishedBy/figure/*.png publishedBy/figure/*.svg)
cd -

# for every country in report/
countries=`ls -d $pathprefix/country/* | grep -v -e XZ -e ZZ`
for country in $countries; do
	countrycode=`echo $country | rev | cut -d \/ -f 1 | rev`
	# echo "$countrycode"
	path=$pathprefix/country/$countrycode
	mkdir -p $path/about/figure $path/publishedBy/figure

	for filename in "${filelist[@]}"; do
		# echo "Checking $country/$filename"
		if [ ! -f $country/$filename ]; then
			# echo "Copying into $country"
			cp -v "$workingdir"/placeholder.${filename##*.} $country/$filename
		fi
	done
done
