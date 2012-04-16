#!/bin/bash

if [ ! -e css ]
then
    echo "=> creating css directory"
    mkdir css
fi

for less_file in ./less/*.less
do
    less_file_bn=`basename $less_file`
    css_file=`echo $less_file_bn|sed 's/\.less/.min.css/'` 
    echo "=> compiling & minifying $less_file to ./css/$css_file"
    lessc -x less_file > ./css/$css_file
done
