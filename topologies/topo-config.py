import sys
import os.path
import argparse
import yaml

# Printing Nodes List Function
def Node_Print (self): 
    table_row = " ---------------------------------"
    counter = 0

    print(table_row)
    print("| Node Name  | IPv4 Management IP |")
    print(table_row)
    for key,value in node_list.items():
        print("| "+key.ljust(10), '|', value.ljust(18)+" |")
        print(table_row)

# Define variables
node_list = {}
config_file ='config_db.yaml'

def is_valid_file(parser, arg):
    filename = arg+"/"+arg+".yml"
    if not os.path.exists(filename):
        parser.error("The file %s does not exist!" % filename)
    else:
        return open(filename, 'r')  # return an open file handle

# Handle cli options passed in
link_options = ['A','B','C','D','E','F','G','H','I']
parser = argparse.ArgumentParser(
    prog = 'Topology Configurator',
        description = 'Backup and Restores topology SONiC container configs',
        epilog = 'topo-config.py -b -r  <topology directory>')
parser.add_argument('-b','--backup', action='store_true') 
parser.add_argument('-r','--restore', action='store_true') 
#parser.add_argument('filename', type=argparse.FileType('r'),required=True)
parser.add_argument(dest='filename',type=lambda x: is_valid_file(parser, x))

# Parse CLI input
args = parser.parse_args()

if args.backup == True:
    print("Backup time")
elif args.restore == True:
    print("Restore time")

# Open YAML topology file and parse to capture node names and IP
with open (args.filename.name,'r') as topology:
    topo_data=yaml.safe_load(topology)

nl = topo_data['topology']['nodes']

for n in nl:
    # add node_name:ip to dictionary
    node_list.update({n:nl[n]['mgmt_ipv4']})

Node_Print(node_list)