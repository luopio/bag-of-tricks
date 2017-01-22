#!/usr/bin/python
''' Just something quick for time calculations '''

from datetime import datetime
import re

clock_format_reg = re.compile('([0-9]{1,2}):([0-9]{2})')
    
def calculate(time_str):
    # test = '17:45 - 30 - 0920 - 45 - 115 + 0:15'
    buf = ""
    nums = []
    last_splitter = time_str[0] if time_str[0] in ('+', '-') else '+'
    # parse in a stream fashion until the end
    for i in xrange(len(time_str)):
        l = time_str[i]
        if l in ('+', '-'):
            seconds = extract_seconds(buf)
            if last_splitter == '-':
                seconds *= -1
            nums.append(seconds)
            buf = ""
            last_splitter = l
        else:
            buf += l

    seconds = extract_seconds(buf)
    if last_splitter == '-':
        seconds *= -1       
    nums.append(seconds)
    return sum(nums)


def extract_seconds(buf):
    buf = buf.strip()
    if buf.find(':') != -1:
        m = clock_format_reg.findall(buf)[0]
        return int(m[0]) * 60 * 60 + int(m[1]) * 60         
    elif len(buf) == 2: # e.g. 45 => handle as minutes
        return int(buf) * 60
    elif len(buf) == 3:
        return int(buf[0]) * 60 * 60 + int(buf[1:]) * 60
    elif len(buf) == 4:
        return int(buf[0:2]) * 60 * 60 + int(buf[2:]) * 60
    else:
        print "(!) dunno how to handle number", buf
        return 0


if __name__ == '__main__':
    print 'Time calculation in the form "<TIME> [+|-] <TIME>", where <TIME> can be format HH:MM, HHMM, HMM, MM.'
    while True:
        t1 = raw_input('(q to quit)" > ')
        if t1 == 'q':
            break
        delta = calculate(t1)
        print "Result = %s:%s" % (delta / 60 / 60, delta / 60 % 60)
    print "Bye. Have a nice day."
