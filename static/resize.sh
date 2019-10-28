#!/bin/bash
srcdir="ddr_couv"
dstdir="ddr_s"
# -quality 10%
# -define "jp2:rate=30"  -compress JPEG2000
for srcfile in $srcdir/*.jpg
do
   # _couv300.jpg
  dstfile=$dstdir/"`basename $srcfile _couv.jpg`_s.jpg"
  echo $dstfile
  magick $srcfile -strip -sigmoidal-contrast 5 -resize x250 -quality 80%  $dstfile
done
