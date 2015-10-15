#!/bin/bash
# take the country code pdfs (named like DK.pdf) from the pdfs/ directory and copy them into report/country/<countrycode>/GBIF_CountryReport_<countrycode>.pdf
echo "Copying country report pdfs from pdfs/ to report/country/"
files=pdfs/*pdf
for file in $files
do
  countrycode=`echo $file | cut -d '.' -f 1 | cut -d '/' -f 2`
  newfile="report/country/$countrycode/GBIF_CountryReport_$countrycode.pdf"
  cp $file $newfile
done
echo "Finished copying country report pdfs"