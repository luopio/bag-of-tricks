#!/bin/sh

FILENAME=$(basename $1)
# Some codecs require divisible by two numbers (e.g. mp4)
# SIZE="660x372"
SIZE="800x452"

echo "======== convert to h264"
ffmpeg -i $1 -acodec libfaac -ab 96k -vcodec libx264 -level 21 -refs 2 -b:v 345k -bt 345k -threads 0 -s $SIZE ${FILENAME%.*}-$SIZE.mp4

echo "======== convert to webm"
ffmpeg -i $1 -acodec libvorbis -ac 2 -ab 96k -ar 44100 -b:v 345k -s $SIZE ${FILENAME%.*}-$SIZE.webm 

echo "======== convert to ogv"
ffmpeg -i $1 -acodec libvorbis -ac 2 -ab 96k -ar 44100 -b:v 345k -s $SIZE ${FILENAME%.*}-$SIZE.ogv 

echo "======== take screenshot from the 3:00 and save as png"
ffmpeg -i $1 -ss 180 -f image2 -vframes 1 ${FILENAME%.*}.png

echo "======== create thumbnail and background with imagemagick"
convert ${FILENAME%.*}.png -resize 300x ${FILENAME%.*}.thumbnail.png
convert ${FILENAME%.*}.png -resize 1200x ${FILENAME%.*}.background.png
