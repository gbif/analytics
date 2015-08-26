#!/bin/bash
target_dir=$1
fonts_dir=$2
echo "Embedding all fonts in pdfs under $1 using fonts from $2"
files=`find "$target_dir" -name '*pdf'`
searched=0
hits=0
for file in $files
do
  ((hits=hits+1))
  tmpfile=$file.tmp
  gsx -sFONTPATH=$fonts_dir -o $tmpfile -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress $file &>/dev/null
  mv $tmpfile $file
  #echo $file
done
echo "Embedded fonts in $hits pdfs"
