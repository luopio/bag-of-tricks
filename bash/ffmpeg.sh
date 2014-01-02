# create a timelapse (filenames need to be sequential)
ffmpeg -r 30 -i G00*.JPG -s hd480 -vcodec libx264 -vpre hq time-lapse.mp4

# convert to WMV with good quality (q:v 2-5)
ffmpeg -i in.mov -q:v 2 -vcodec wmv2 -acodec wmav2 -ar 44100 -ab 48000 -y out.wmv

# grab a frame from a video
# position may be either in seconds or in "hh:mm:ss[.xxx]" form.
ffmpeg -i input.flv -ss 00:00:14.435 -f image2 -vframes 1 out.png

# three commands for web video conversions
# Note that you'll need proper ffmpeg. On Mac this can be achieved with 
# brew install ffmpeg --with-libvpx --with-theora --with-libogg --with-libvorbis

# OGG/Theora
ffmpeg -i input.mov -acodec libvorbis -ac 2 -ab 96k -ar 44100 -b:v 345k -s 640x360 output.ogv

# WebM/vp8
ffmpeg -i big_buck_bunny.avi -acodec libvorbis -ac 2 -ab 96k -ar 44100 -b:v 345k -s 640x360 big_buck_bunny.webm 

# also two-pass is recommended by some people for better quality:
ffmpeg -i "/home/user/input_video.mpg" -codec:v libvpx -quality good -cpu-used 0 -b:v 600k -qmin 10 -qmax 42 -maxrate 500k -bufsize 1000k -threads 2 -vf scale=-1:480 -an -pass 1 -f webm /dev/null
# pass 2
ffmpeg -i "/home/user/input_video.mpg" -codec:v libvpx -quality good -cpu-used 0 -b:v 600k -qmin 10 -qmax 42 -maxrate 500k -bufsize 1000k -threads 2 -vf scale=-1:480 -codec:a libvorbis -b:a 128k -pass 2 -f webm output.webm

# MP4/h264
ffmpeg -i input.mov -acodec libfaac -ab 96k -vcodec libx264 -level 21 -refs 2 -b:v 345k -bt 345k \
 -threads 0 -s 640x360 output.mp4
