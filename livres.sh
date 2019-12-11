if [ -z "$1" ] 
then
	echo "Quel fichier ? ../Rougemont/livres/*.xml ?"
	exit
fi
xsltproc static/vendor/teinte-livre.xsl  "$@"
