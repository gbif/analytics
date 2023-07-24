#!/bin/zsh -e
#
# Fill countries/areas on a map based on a table of values, e.g.
#   IS 1
#   NO 2
#   SJ 3
# with tab or space separation.
#
# Run as
#   ./generate-country-map.sh -i sourceTable -o output.svg -t 'Map title' -l 'Map legend title'
#
# The map source is "BlankMap-World.svg" from Wikimedia Commons, which is in the public domain.  This map
# may as well be in the public domain too.  Check the file history in case there are updates.
# https://commons.wikimedia.org/wiki/File:BlankMap-World.svg
#

projection=robinson

land='#fbfbfb'
gt1='#cbdbc5'
gt2='#b8ceb0'
gt4='#a6c19b'
gt10='#94b487'
gt40='#82a872'
gt100='#5a964d'

while getopts "i:o:t:l:p:" opt; do
    case $opt in
        i)
            # Set input file
            input=$OPTARG
            ;;
        o)
            # Set output file
            outputSvg=$OPTARG
            ;;
        t)
            # Set map title
            title=$OPTARG
            ;;
        l)
            # Set legend title
            legend=$OPTARG
            ;;
        p)
            # Override projection
            projection=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            echo
            print_usage
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

echo "Generating $outputSvg from $input, title $title legend $legend."

if [[ -z $input ]]; then echo &>2 "-i <input> must be set"; exit 1; fi
if [[ -z $outputSvg ]]; then echo &>2 "-o <outputSvg> must be set"; exit 1; fi

sed "s/World Map/$title/" < ${0:a:h}/$projection-map.head > $outputSvg
echo >> $outputSvg

echo "/* Colour scale:" >> $outputSvg
echo "Land: $land" >> $outputSvg
echo "≥  1 $gt1" >> $outputSvg
echo "≥  2 $gt2" >> $outputSvg
echo "≥  4 $gt4" >> $outputSvg
echo "≥ 10 $gt10" >> $outputSvg
echo "≥ 40 $gt40" >> $outputSvg
echo "≥100 $gt100" >> $outputSvg
echo "*/" >> $outputSvg
echo >> $outputSvg

echo "/* Begin calculated styles */" >> $outputSvg
echo >> $outputSvg

typeset -A countPerCountry

for country total in $(cat $input); do
        countPerCountry[$country]=$total
done

for country total in ${(kv)countPerCountry}; do

    if [[ $total -ge 100 ]]; then
        colour=$gt100
    elif [[ $total -ge 40 ]]; then
        colour=$gt40
    elif [[ $total -ge 10 ]]; then
        colour=$gt10
    elif [[ $total -ge 4 ]]; then
        colour=$gt4
    elif [[ $total -ge 2 ]]; then
        colour=$gt2
    else
        colour=$gt1
    fi

    if [[ $total = VOTING ]]; then
        colour=$gt100
    elif [[ $total = ASSOCIATE ]]; then
        colour=$gt2
    fi

    echo "/* $country has $total */" >> $outputSvg
    echo "path#${country:l}, g#${country:l} > path, g#${country:l} > circle, g#${country:l}- > path { fill: $colour; opacity: 1; }" >> $outputSvg
done

echo >> $outputSvg
echo "/* Remaining countries */" >> $outputSvg
for country in $(curl -Ss https://api.gbif.org/v1/enumeration/country | jq -r '.[].iso2'); do
    if [[ -z "$countPerCountry[$country]" ]]; then
        echo "path#${country:l}, g#${country:l} > path, g#${country:l} > circle, g#${country:l}- > path { fill: ${land}; }" >> $outputSvg
        echo "g#${country:l} > circle { opacity: 0; }" >> $outputSvg
    fi
done

echo >> $outputSvg
echo "/* End calculated styles */" >> $outputSvg
echo >> $outputSvg

cat ${0:a:h}/$projection-map.tail >> $outputSvg

if [[ -n "$legend" ]]; then
    sed "s/Number of active publishers by country or area/$legend/" < ${0:a:h}/$projection-map.legend >> $outputSvg
fi

echo "</svg>" >> $outputSvg
