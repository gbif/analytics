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

while getopts "i:o:t:l:" opt; do
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

sed "s/World Map/$title/" < ${0:a:h}/robinson-map.head > $outputSvg
echo >> $outputSvg
echo "/* Begin calculated styles */" >> $outputSvg
echo >> $outputSvg

typeset -A countPerCountry

for country total in $(cat $input); do
        countPerCountry[$country]=$total
done

for country total in ${(kv)countPerCountry}; do

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

    echo "/* $country has $total */" >> $outputSvg
    echo "path#${country:l}, g#${country:l} > path, g#${country:l} > circle, g#${country:l}- > path { fill: $colour; opacity: 1; }" >> $outputSvg
done

echo >> $outputSvg
echo "/* Remaining countries */" >> $outputSvg
for country in $(curl -Ss https://api.gbif.org/v1/enumeration/country | jq -r '.[].iso2'); do
    if [[ -z "$countPerCountry[$country]" ]]; then
        echo "path#${country:l}, g#${country:l} > path, g#${country:l} > circle, g#${country:l}- > path { fill: #c0c0c0; }" >> $outputSvg
        echo "g#${country:l} > circle { opacity: 0; }" >> $outputSvg
    fi
done

echo >> $outputSvg
echo "/* End calculated styles */" >> $outputSvg
echo >> $outputSvg

sed "s/Number of active publishers by country or area/$legend/" < ${0:a:h}/robinson-map.tail >> $outputSvg
