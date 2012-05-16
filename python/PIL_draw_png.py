import Image
import ImageDraw

X_SIZE = 10
Y_SIZE = 10

def draw_spot(x, y, color, dw):
    dw.rectangle((x * X_SIZE, y * Y_SIZE, X_SIZE, Y_SIZE), fill=color) 

cols = 8
rows = 8
img = Image.new('L', (X_SIZE * cols, Y_SIZE * rows), color=255)
draw = ImageDraw.Draw(img)

for yi in xrange(0, rows):
    for xi in xrange(0, cols):
         draw_spot(xi, yi, (xi * 5) + yi * 10, draw)

img.save('/tmp/output.png')
