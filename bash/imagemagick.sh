# Create a CSS sprite from several files
convert smiley-?.png -append smiley-sprites.png

# Create tiles with a running number from a large file
convert finland_full_bw.png -crop 432x432 tiles/%d.jpg
