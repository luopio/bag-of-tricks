#!/bin/bash

if [ ! -e js ]
then
    echo "=> creating js directory"
    mkdir js
fi

for coffee_file in ./coffee/*.coffee
do
    coffee_file_bn=`basename $coffee_file`
    js_file=`echo $coffee_file_bn|sed 's/\.coffee/.cf.js/'` 
    echo "=> compiling $coffee_file to ./js/$js_file"
    coffee -cp $coffee_file > ./js/$js_file
done
