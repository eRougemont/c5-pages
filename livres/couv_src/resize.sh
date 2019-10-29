#!/bin/bash
srcdir="couv_src"
dstdir="couv"
for srcfile in $srcdir/*.jpg
do
   # _couv300.jpg
  dstname="`basename $srcfile _couv.jpg`"
  echo $dstname
  magick $srcfile -strip -sigmoidal-contrast 5 -resize x250 -quality 80%  $dstdir/$dstname"_s.jpg"
  magick $srcfile -strip -sigmoidal-contrast 5 -resize x500 -quality 80%  $dstdir/$dstname"_m.jpg"
done
