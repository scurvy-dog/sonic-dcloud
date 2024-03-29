# from 1-SONiC_101/vxr/ directory run "python3 get_mgt_ips.py"

import os
import json

# correlate symlynk name to pyvxr directory 
print("""
symlink correlation: """)
lf1 = os.popen('ls -la /nobackup/root/pyvxr/leaf-1').read().strip()
leaf1 = lf1[-9:]
lf2 = os.popen('ls -la /nobackup/root/pyvxr/leaf-2').read().strip()
leaf2 = lf2[-9:]
sp1 = os.popen('ls -la /nobackup/root/pyvxr/spine-1').read().strip()
spine1 = sp1[-9:]
sp2 = os.popen('ls -la /nobackup/root/pyvxr/spine-2').read().strip()
spine2 = sp2[-9:]
print(leaf1 + " is leaf-1")
print(leaf2 + " is leaf-2")
print(spine1 + " is spine-1")
print(spine2 + " is spine-2")

# grep arp entries for virbr0
# comment out these two lines unless running script on dcloud linux host
arptable = os.popen('arp -an | grep virbr0').read().strip()
print("""
grep arp table""")

print(arptable + """
      """)

# Test data: uncomment the next 4 lines to have local test data

# arptable = """? (192.168.122.82) at 02:62:8b:b6:a3:bd [ether] on virbr0
# ? (192.168.122.62) at 02:36:0f:98:64:cc [ether] on virbr0
# ? (192.168.122.157) at 02:2d:41:3a:64:9d [ether] on virbr0
# ? (192.168.122.122) at 02:3b:1c:53:20:5b [ether] on virbr0"""

# split big arp table string into searchable lines
tlist = arptable.split("\n")

# for loop parses arp table output, identifies ip and mac
for l in tlist:
    pl = l.split(" ")
    pl = [w.replace('?', 'ip') for w in pl]
    pl = [w.replace('at', 'mac') for w in pl]
    del pl[4:7]
    pl = ' '.join(pl).replace('(','').split()
    pl = ' '.join(pl).replace(')','').split()

    # convert output to all caps to match mac address in ConfigVector.txt
    up = [x.upper() for x in pl]

    ipaddr = up[1]

    # correlate parsed arp with pyvxr directory/id
    dir = os.popen('grep -r ' + up[3] + ' /nobackup/root/pyvxr/p*lcc0lc0/ConfigVector.txt').read().strip()
    
    if dir[21:30] == leaf1:
        print("leaf-1 has ip " + ipaddr)
    if dir[21:30] == leaf2:
        print("leaf-2 has ip " + ipaddr)
    if dir[21:30] == spine1:
        print("spine-1 has ip " + ipaddr)
    if dir[21:30] == spine2:
        print("spine-2 has ip " + ipaddr)
    




 