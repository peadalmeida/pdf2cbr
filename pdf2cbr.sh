#!/bin/sh
#
# PDF2CBR
# by: @pedroaugusto
#

echo "Criando diretório PDF..."
mkdir $1_pages
cd $1_pages
pdftk ../$1 burst


if [ -e doc_data.txt ]
	then
	rm -f doc_data.txt
fi

PAGE_COUNT=`ls | wc -l`
echo "Convertendo páginas para JPEG"

for file in *.pdf
do
	convert -density 100x100 $file $file.jpg
	rm -f $file
	let PAGE_COUNT--
done

for file in *.jpg
do
	mv $file ${file%pdf.*}jpg
done

echo "Criando arquivo RAR"
rar a $1.rar *.jpg
echo "Renomeando arquivo RAR para CBR"
mv $1.rar ../$1.cbr
echo "Removendo lixo"
cd ..
rm -Rf $1_pages
if [ -e $1.cbr ]
then
echo "File $1.cbr generated."
fi

echo "Pronto! Boa leitura!"