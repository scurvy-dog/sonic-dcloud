import os
import json

d = os.popen('arp -an | grep virbr0').read().strip()
print(d)

# d = """? (192.168.122.82) at 02:62:8b:b6:a3:bd [ether] on virbr0
# ? (192.168.122.62) at 02:36:0f:98:64:cc [ether] on virbr0
# ? (192.168.122.157) at 02:2d:41:3a:64:9d [ether] on virbr0
# ? (192.168.122.122) at 02:3b:1c:53:20:5b [ether] on virbr0"""

dl = d.split("\n")

def Convert(lst):
    res_dct = map(lambda i: (lst[i], lst[i+1]), range(len(lst)-1)[::2])
    return dict(res_dct)

for l in dl:
    ml = []
    pl = l.split(" ")
    pl = [w.replace('?', 'ip') for w in pl]
    pl = [w.replace('at', 'mac') for w in pl]
    del pl[4:7]
    pl = ' '.join(pl).replace('(','').split()
    pl = ' '.join(pl).replace(')','').split()

    # Driver code
    lst = pl
    cl = (Convert(lst))

    ml.append(cl)
    print(ml)


 