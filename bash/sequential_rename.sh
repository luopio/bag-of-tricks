#!/bin/bash
# rename a bunch of files to a sequential order
# with zero padded filenames. 

INDEX=0

# for f in `ls -1rt *.JPG`
for f in `ls -1 *.JPG`
do
  new_name=`printf %05d $INDEX`.jpg
  echo "$f => $new_name"
  mv $f $new_name
  INDEX=$(($INDEX+1))
done

