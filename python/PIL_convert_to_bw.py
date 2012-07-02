''' Convert an image to black and white '''
import Image

if __name__ == '__main__':
    import sys
    image_file = Image.open(sys.argv[1]) # open colour image
    image_file = image_file.convert('1') # convert image to black and white
    image_file.save(sys.argv[1][:-4] + '-bw.png')