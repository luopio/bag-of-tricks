mkdir tmp

gifblender -s 6 -o tmp *.jpg

INDEX=0
for f in `ls -1 *.jpg`
do
 new_name=`printf %05d $INDEX`.jpg
 echo "$f => $new_name"
 mv $f $new_name
 INDEX=$(($INDEX+1))
done

ffmpeg -f image2 -i %05d.jpg -s hd480 -r 6 -vcodec h264 time-lapse-1.mp4

ffmpeg -i time-lapse-1.mp4 -i /Users/lauri/Downloads/Drunken\ Sailer\ -\ Irish\ Rovers.mp3 -af "volume=0.25" -shortest pihjalasaareen.mp4