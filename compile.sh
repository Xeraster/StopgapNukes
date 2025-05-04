#!/bin/bash
MODNAME=StopgapNukes
VERSION=1.0.7
DIRNAME=$MODNAME"_"$VERSION
FILENAME=$MODNAME"_"$VERSION.zip
echo $FILENAME
#sorry for the sh file, I'm just really lazy

#workaround because it's "impossible" to zip a directory into a zipfile if you're trying to zip the same directory you're trying to zip.. i guess
mkdir ../$DIRNAME

#2nd workaround because zip completely lacks the ability to understand what "../" means
cp -r * ../$DIRNAME/
mv ../$DIRNAME $DIRNAME #put the directory to zip into THIS directory, bypassing all 3 issues making this task otherwise not possible

#zip the contents of this entire directory into a single file
zip -r $FILENAME $DIRNAME

#destroy all evidence of this ugly hack
rm -r $DIRNAME

#copy the newly created zip file to the correct location in factorio mods
cp $FILENAME "/home/scott/GOG Games/Factorio/game/mods/"

#remove this or it'll mess upo the next "compile" operation
rm $FILENAME 
