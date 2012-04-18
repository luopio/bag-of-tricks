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
import os, dircache, re, shutil

BUILD_DIR = 'BUILD'
AUTOMATICALLY_INCLUDED_FILES = ('robots.txt', 'humans.txt') 
AUTOMATICALLY_INCLUDED_FILE_SUFFIXES = ('html', )


def bootstrap():
    if os.path.isdir(BUILD_DIR):
        print "bootstrap: error - %s directory already exists" % BUILD_DIR
    else:
        os.mkdir(BUILD_DIR)


def look_for_included_files():
    ''' Look for the first files that should be automatically included '''
    for f in dircache.listdir('.'):
        if f in AUTOMATICALLY_INCLUDED_FILES:
            shutil.copy(f, BUILD_DIR)
        else:
            if '.' in f:
                suffix = f.rsplit('.', 1)[1]
                if suffix in AUTOMATICALLY_INCLUDED_FILE_SUFFIXES:
                    shutil.copy(f, BUILD_DIR)


def look_for_required_files():
    ''' Look for files that are needed by the files in the build and include
    those '''
    needed_files_by_file = {}
    for f in dircache.listdir(BUILD_DIR):
        if os.path.isfile(f):
            needed_files_by_file[f] = scan_for_file_links_in_html(f) 
    # look for potential files required by these files
    for from_file, files in needed_files_by_file.items():
        for f in files:
            if not os.path.exists(f):
                continue
            suf = f.rsplit('.', 1)[1] 
            if suf in ('less', 'css'):
                needed_files_by_file[f] = [os.path.join( os.path.dirname(f), ff) for ff in scan_for_file_links_in_css(f)]
            elif suf in ('js', 'coffee'):
                pass # needed_files_by_file[f] = [os.path.join( os.path.dirname(f), ff) for ff in scan_for_file_links_in_js(f)]

    return needed_files_by_file

def scan_for_file_links_in_css(f):
    fc = open(f, 'rt').read()
    css_file_refs = re.compile(r'url\(["\']?([\w.\-:/\n]+\.\w{3,})["\']?\)')
    all_files = css_file_refs.findall(fc) 
    return all_files

def scan_for_file_links_in_html(f):
    fc = open(f, 'rt').read()
    general_file_path_ref = re.compile(r'[\w-]{3,}=["\']?([\w.\-:/\n]+\.\w{2,})["\']?')
    all_files = general_file_path_ref.findall(fc)
    return all_files 

def scan_for_file_links_in_js(f):
    fc = open(f, 'rt').read()
    css_file_refs = re.compile(r'["\']?([\w.\-:/\n]+\.\w{2,})["\']?')
    all_files = css_file_refs.findall(fc) 
    return all_files

def copy_files_to_build(files_by_file):
    not_founds = []
    copied = 0
    for from_file, files in files_by_file.items():
        for f in files:
            if f.startswith('http:') or f.startswith('https:'):
                continue
            if not os.path.exists(f):
                not_founds.append((f, from_file))
            else:
                dirname = os.path.join(BUILD_DIR, os.path.dirname(f))
                if not os.path.isdir(dirname):
                    os.makedirs(dirname)
                target = os.path.join(dirname, os.path.basename(f))
                # print "copy from", f, "to", target
                shutil.copy(f, target)
                copied += 1
    if not_founds:
        print 
        print "WARNING: the following files were linked in files, but not found"
        for f, from_file in not_founds: print "%s (requested in %s)" % (f, from_file)
        print

    print "Copied %s files" % copied
    return not_founds


def compress_js():
    print "compressing javascript files"
    ignore_js = [r'modernizer*\.js', 'jquery*\.js']


def compile_less():
    print "compiling less files"


def compress_css():
    print "compressing css files"


if __name__=='__main__':
    bootstrap()
    look_for_included_files()
    needed_files = look_for_required_files()
    copy_files_to_build(needed_files)
