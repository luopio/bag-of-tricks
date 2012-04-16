#!/usr/bin/python
""" 
    Objective:
        #1 minimize the amount of requests
        #2 minimize the size of requests

    Workflow dream:
    - create a build directory and scan files that
      are used. Only copy those files to the directory
        - assume all html files are used, then search for
          css and images, then js and css and images
        - assume humans.txt, robots.txt, etc.

    - look for JS files, concatenate and compress
      - skip files like modernizer and jquery base

    - look for CSS files, concatenate and minimize
      - compile less files automatically

    - replace all occurences in HTML files
      - validate html files (FYI level)

    - optimize PNG, JPG
    
    How about:
        - look for occurences in html files, when found,
        concatenate all files in the same file together
        and compress

"""


def compress_js():
    print "compressing javascript files"
    ignore_js = [r'modernizer*\.js', 'jquery*\.js']


def compile_less():
    print "compiling less files"


def compress_css():
    print "compressing css files"


if __name__=='__main__':
    print "looking for files to minimize"
