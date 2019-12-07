srcdir=../ddr-articles
dstdir=articles
list=$dstdir/list.xml

echo \<list\> > $list
for srcfile in $srcdir/*.xml
do
  basename=$(basename -- "$srcfile")
  echo  \<file\>$basename\</file\> >> $list
done
echo \</list\> >> $list

xsltproc -o $dstdir/index.html --stringparam srcdir ../../$srcdir/ static/vendor/teinte-list.xsl  $dstdir/list.xml


xsl=static/vendor/teinte-article.xsl
for srcfile in $srcdir/*.xml
do
  basename=$(basename -- "$srcfile")
  name="${basename%.*}"
  id="${name%_*}"
  echo $basename
  xsltproc -o $dstdir/$name.html --stringparam id $id $xsl $srcfile

done
