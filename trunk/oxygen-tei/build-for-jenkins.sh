#!/bin/bash
# NOT FINISHED YET. DO NOT USE.
# Martin Holmes 2015
# Based on Sebastian Rahtz's update-and-upload.sh.
# Grab TEIP5 and XSL builds from other Jenkins workspaces, 
# rebuilds the distribution, and stashes it for testing.
#
die()
{
    echo; echo
    echo "ERROR: $@."
    D=`date "+%Y-%m-%d %H:%M:%S"`
    echo "$D. That was a fatal error"
    exit 1
}
# First we need to find out the versions of the Stylesheets and P5.
CURRDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
P5LOCREL="$CURRDIR/../../../TEIP5/lastSuccessful/archive/"
P5LOC=$(readlink -f $P5LOCREL)
TEIVERSIONFILE="$P5LOC/release/doc/tei-p5-doc/VERSION"
TEIVERSION=$(cat $TEIVERSIONFILE)
echo "TEI version is $TEIVERSION"
XSLLOCREL="$CURRDIR/../../../Stylesheets/lastSuccessful/archive/"
XSLLOC=$(readlink -f $XSLLOCREL)
XSLVERSIONFILE="$XSLLOC/dist/doc/tei-xsl/VERSION"
XSLVERSION=$(cat $XSLVERSIONFILE)
echo "Stylesheets version is $XSLVERSION"


if [ -z $TEIVERSION ] 
then
 echo "Unable to read the TEI VERSION file at $TEIVERSIONFILE"
 exit 1
fi
if [ -z $XSLVERSION ] 
then
  echo "Unable to read the XSL Stylesheets VERSION file at $XSLVERSIONFILE"
 exit 1
fi

#Make sure we're in the right location for what follows.
cd $CURRDIR
if [ ! -e lib/oxygen.jar ]
then
  cp ../../oxygen.jar lib/oxygen.jar
fi

if [ ! -e lib/oxygen.jar ]
then
  echo "oxygen.jar is missing from the lib folder. Unable to continue."
  exit 1
fi

echo "Retrieve $P5LOC/tei-$TEIVERSION.zip"
cp $P5LOC/tei-$TEIVERSION.zip tei.zip 
if [ $? -ne 0 ]; then
    echo "Retrieval of $P5LOC/tei-$TEIVERSION.zip failed."
    exit 1
fi
echo "Retrieve $XSLLOC/tei-xsl-$XSLVERSION.zip"
cp $XSLLOC/tei-xsl-$XSLVERSION.zip xsl.zip
if [ $? -ne 0 ]; then
    echo "Retrieval of $XSLLOC/tei-xsl-$XSLVERSION.zip failed."
    exit 1
fi

cd frameworks/tei
echo "Zap any old versions..."
rm -rf xml/tei/Test 
rm -rf xml/tei/custom/odd
rm -rf xml/tei/custom/schema
rm -rf xml/tei/odd
rm -rf xml/tei/schema
rm -rf xml/tei/stylesheet
rm -rf xml/tei/xquery
echo "Unpack new files..."
unzip -o -q ../../tei.zip
unzip -o -q ../../xsl.zip
echo "Remove unwanted material..."
rm -f xml/tei/Exemplars/*epub
rm -f xml/tei/Exemplars/*html
rm -f xml/tei/Exemplars/*pdf
rm -f xml/tei/Exemplars/*tex
rm -f xml/tei/Exemplars/*compiled
rm -f tei/xml/tei/odd/p5subset.js
rm -f tei/xml/tei/odd/p5subset.json
rm -f tei/xml/tei/odd/p5attlist.txt
rm -rf doc
rm -rf xml/tei/Test 
rm -rf xml/tei/odd/ReleaseNotes
rm -rf xml/tei/odd/Source
rm -rf xml/tei/odd/Exemplars
rm -rf xml/tei/Exemplars
rm -rf xml/tei/odd/*.css
rm -rf xml/tei/odd/p5subset.j*
rm -rf xml/tei/odd/Utilities
rm -rf xml/tei/odd/p5odds-examples.*
rm -rf xml/tei/odd/webnav
rm -rf xml/tei/xquery
rm -rf templates/TEI\ P5
mkdir -p templates/TEI\ P5
mv xml/tei/custom/templates/* templates/TEI\ P5
rm templates/TEI\ P5/tei_*.doc.xml
cd ../..
echo "Add Brown specifics..."
unzip brown
rm -f tei.zip xsl.zip frameworks/tei/dist/tei.zip
echo "Do Ant build..."
(cd frameworks/tei; ant)
if [ ! -f frameworks/tei/dist/tei.zip ] 
then
 echo "Failed to create distribution."
 exit 1
fi
cd $CURRDIR
echo "Move result to oxygen-tei-$TEIVERSION-$XSLVERSION.zip"
mv frameworks/tei/dist/tei.zip oxygen-tei-$TEIVERSION-$XSLVERSION.zip
echo "Complete. Build should be available at oxygen-tei-$TEIVERSION-$XSLVERSION.zip."