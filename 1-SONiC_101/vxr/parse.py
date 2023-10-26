# from 1-SONiC_101/vxr/ directory run "python3 parse.py"

import os
import json

# grep arp entries for virbr0
# comment out these two lines unless running script on dcloud linux host
d = os.popen('arp -an | grep virbr0').read().strip()
print("grep arp table")
print(d + """
      """)

# Test data: uncomment the next 4 lines to have local test data

# d = """? (192.168.122.82) at 02:62:8b:b6:a3:bd [ether] on virbr0
# ? (192.168.122.62) at 02:36:0f:98:64:cc [ether] on virbr0
# ? (192.168.122.157) at 02:2d:41:3a:64:9d [ether] on virbr0
# ? (192.168.122.122) at 02:3b:1c:53:20:5b [ether] on virbr0"""

dl = d.split("\n")

# function used later in code to convert list to dict - may not be needed

# def Convert(lst):
#     res_dct = map(lambda i: (lst[i], lst[i+1]), range(len(lst)-1)[::2])
#     return dict(res_dct)

# for loop parses arp output, identifies IP and MAC
for l in dl:
    pl = l.split(" ")
    pl = [w.replace('?', 'ip') for w in pl]
    pl = [w.replace('at', 'mac') for w in pl]
    del pl[4:7]
    pl = ' '.join(pl).replace('(','').split()
    pl = ' '.join(pl).replace(')','').split()

    up = [x.upper() for x in pl]
    #print(up)

    ip = up[1]

    # correlate parsed arp with pyvxr directory/id
    corr = os.popen('grep -r ' + up[3] + ' /nobackup/root/pyvxr/p*lcc0lc0/ConfigVector.txt').read().strip()
    print("node " + corr[21:29] + " has ip " + up[1])

    # convert to dict - probably not needed
    # lst = pl
    # clst = [x.upper() for x in lst]
    # cl = (Convert(clst))
    #print(cl)

# correlate symlynk name to pyvxr directory 
print("""
symlink correlation: """)
lf = os.popen('ls -la /nobackup/root/pyvxr/leaf-*').read().strip()
sp = os.popen('ls -la /nobackup/root/pyvxr/spine-*').read().strip()
print(lf)
print(sp)


 