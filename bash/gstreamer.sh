# capture one frame on the webcam
v4l2src num-buffers=1 ! ffmpegcolorspace ! video/x-raw-yuv,width=640,height=480,framerate=8/1 ! jpegenc ! filesink location=test.jpg 

gst-launch v4l2src ! jpegdec ! ffmpegcolorspace ! ximagesink

mplayer -vo png -frames 1 tv://

ffmpeg -t 1 -f video4linux2 -s 320x240 -i /dev/video0 -r 1 -f image2 ~/camera%05d.png
