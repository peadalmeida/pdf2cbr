#!/bin/sh
#
# PDF2CBR
#
#

echo "Creating pdf directory..."
mkdir $1_pages
cd $1_pages

echo "Splitting .pdf file into individual pdfs..."
pdftk ../$1 burst

echo "Removing PDFtk report"
if [ -e doc_data.txt ]; then
	rm -f doc_data.txt
fi

PAGE_COUNT=`ls | wc -l`
echo "$PAGE_COUNT pdfs generated."

echo "Converting each .pdf page to .jpg..."
for file in *.pdf
do
	convert -density 100x100 $file $file.jpg
	rm -f $file
	let PAGE_COUNT--
	echo "$PAGE_COUNT pages left."
done

echo "remove .pdf from filenames"
for file in *.jpg
do
	mv $file ${file%pdf.*}jpg
done

echo "Creating .rar file..."
rar a $1.rar *.jpg

echo "Renaming .rar to .cbr format..."
mv $1.rar ../$1.cbr

echo "Removing used directory and remaining garbage..."
cd ..
rm -Rf $1_pages
if [ -e $1.cbr ] ; then
	echo "File $1.cbr generated."
fi

echo "All done! Good reading!"
