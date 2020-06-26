if [ -z "$1" ] 
then
	echo "Quel fichier ? ../Rougemont/livres/*.xml ?"
	exit
fi
xsltproc c5/tei2c5.xsl  "$@"
