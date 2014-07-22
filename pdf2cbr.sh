#!/bin/sh
#
# 
# Parameters: only the PDF filename.
#
# Requirements: ImageMagick Convert, RAR and PDFTK
#
echo "Creating PDF directory..."
mkdir $1_pages
cd $1_pages
pdftk ../$1 burst


if [ -e doc_data.txt ]
	then
	rm -f doc_data.txt
fi

PAGE_COUNT=`ls | wc -l`
echo "Converting the pages to JPEG"

for file in *.pdf
do
	convert -density 100x100 $file $file.jpg
	rm -f $file
	let PAGE_COUNT--
	echo "$PAGE_COUNT pages left."
done

for file in *.jpg
do
	mv $file ${file%pdf.*}jpg
done
echo "Creating RAR file..."
rar a $1.rar *.jpg
echo "Renaming RAR to CBR format..."
mv $1.rar ../$1.cbr
echo "Removing the garbage..."
cd ..
rm -Rf $1_pages

echo "Done!"
