''' Just something quick for time calculations '''

from datetime import datetime
import re

def calcall(time_str):
    ''' time_str something like '17:40 - 8:20 - 0:30 - 0:50' '''
    reg = re.compile('([0-9]{1,2}:[0-9]{2})\s?-?\s?')
    match = reg.findall(time_str)
    print match
    times = []
    for m in match:
        t = m.split(':')
        seconds = int(t[0]) * 60 * 60 + int(t[1]) * 60 
        times.append(seconds)
    t = times[0]
    for tt in times[1:]:
        t -= tt
    return t

    # times = time_str.split()
    # time1 = datetime.strptime(time1, '%H:%M')
    


while True:
    t1 = raw_input('Time calculation in the form "HH:MM - HH:MM ... (q to quit)" > ')
    if t1 == 'q':
        break
    delta = calcall(t1)
    print "Difference: %s:%s" % (delta / 60 / 60, delta / 60 % 60)

    # t1 = raw_input('Start time (HH:MM), or q to quit: ')
    #t2 = raw_input('End time (HH:MM): ')
    #delta = calcdiff(t1, t2)
    #if delta:
    #    print "Difference between: %s:%s" % (delta.seconds / 60 / 60, delta.seconds / 60 % 60)
    #print


print "Bye. Have a nice day."
