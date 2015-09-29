# copy the placeholder image into place for every missing chart, for each of about/print and publishedBy/print

# full path to dir of this script
workingdir=`dirname $0`/
# report path prefix
pathprefix="report/"

filelist=(occ_animaliaBoR.pdf	occ_complete_date.pdf	occ_complete_geo_specimen.pdf	occ_complete_specimen.pdf	spe_kingdom_observation.pdf occ_cells_half_deg.pdf \
occ_complete_date_observation.pdf occ_complete_kingdom.pdf occ_kingdom.pdf spe_kingdom_specimen.pdf occ_cells_one_deg.pdf occ_complete_date_specimen.pdf \
occ_complete_kingdom_observation.pdf occ_plantaeBoR.pdf spe_repatriation.pdf occ_cells_point_one_deg.pdf occ_complete_geo.pdf	occ_complete_kingdom_specimen.pdf \
occ_repatriation.pdf occ_complete.pdf occ_complete_geo_observation.pdf occ_complete_observation.pdf spe_kingdom.pdf)

cr_filelist=(downloaded_records_by_month.pdf web_traffic_session_by_week.pdf)

# for every country in report/
countries=`ls -d $pathprefix/country/*`
for country in $countries
do
  countrycode=`echo $country | rev | cut -d \/ -f 1 | rev`
  # echo "$countrycode"
  aboutpath="$pathprefix"country/$countrycode/about/print
  if [ ! -d $aboutpath ]; then
    echo "Creating $aboutpath"
    mkdir -p $aboutpath
  fi
  pubpath="$pathprefix"country/$countrycode/publishedBy/print
  if [ ! -d $pubpath ]; then
    echo "Creating $pubpath"
    mkdir -p $pubpath
  fi
  crpath="$pathprefix"country/$countrycode/country_reports
  if [ ! -d $crpath ]; then
    echo "Creating $crpath"
    mkdir -p $crpath
  fi
  
  for filename in "${filelist[@]}"
  do
    # echo "Checking $filename"
    aboutfile="$aboutpath/$filename"
    if [ ! -f $aboutfile ]; then
      echo "Copying into $aboutfile"
      cp "$workingdir"placeholder.pdf "$aboutfile"
    fi
    pubfile="$pubpath/$filename"
    if [ ! -f $pubfile ]; then
      echo "Copying into $pubfile"
      cp "$workingdir"placeholder.pdf "$pubfile"
    fi
  done
  
  for filename in "${cr_filelist[@]}"
  do
    # echo "Checking $filename"
    crfile="$crpath/$filename"
    if [ ! -f $crfile ]; then
      echo "Copying into $crfile"
      cp "$workingdir"placeholder.pdf "$crfile"
    fi
  done
done