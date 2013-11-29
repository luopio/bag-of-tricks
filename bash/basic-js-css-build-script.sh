#!/bin/bash

SCRIPTS="js/vendor/jquery-1.10.2.min.js \
    js/vendor/jquery.easing.1.3.js \
    js/vendor/dragscrollable.js \
    js/vendor/hogan-2.0.0.js \
    js/vendor/sammy.js \
    js/plugins.js \
    js/main.js \
    js/itis.js \
    js/itis.clockloop.js \
    js/itis.dataLoader.js \
    js/itis.pageHandler.js \
    js/itis.locale.js" 

CSS="css/MyFontsWebfontsKit.css \
    css/normalize.css \
    css/main.css"

OUTDIR="out"

# create scaffold for out dir
rm -rf $OUTDIR
mkdir -p $OUTDIR/css
mkdir -p $OUTDIR/js/vendor
cp -r img $OUTDIR
cp js/vendor/modernizr* $OUTDIR/js/vendor/

# handle js
uglifyjs $SCRIPTS > $OUTDIR/js/bundled.js

# handle css
cat $CSS > $OUTDIR/css/bundled.css

# handle html - activate bundled sources
# content between <!-- DEVELOPMENT --> ... <!-- /DEVELOPMENT --> is removed and
# commenting blocks <!-- PRODUCTION ... /PRODUCTION --> are removed to activate bundle.css/js
# all block starters should be on their own lines
sed '/<!-- DEVELOPMENT -->/,/<!-- \/DEVELOPMENT -->/c\' index.html > $OUTDIR/index.html 
sed 's/<!-- PRODUCTION//g' $OUTDIR/index.html > $OUTDIR/index.html.foo  
sed 's/\s*\/PRODUCTION -->//g' $OUTDIR/index.html.foo > $OUTDIR/index.html 
rm $OUTDIR/index.html.foo
