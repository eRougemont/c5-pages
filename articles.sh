srcdir=../ddr-articles/*.xml
xsl=static/vendor/teinte-article.xsl
dstdir=articles
for srcfile in $srcdir
do
  basename=$(basename -- "$srcfile")
  name="${basename%.*}"
  id="${name%_*}"
  echo $basename
  xsltproc -o $dstdir/$name.html --stringparam id $id $xsl $srcfile

done
