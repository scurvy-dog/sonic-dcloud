### SONiC VM to SONiC VM 
Uses UDP assigned ports to map interfaces in a pseudo private line configuration.

In the xml configuration file for each VM map
  - Map source port to source port
  - Map dest port to local port


|sourc vm |dest vm | source port | dest port   | source vm intf | dest vm intf   | 
|*---------|*-------*|*-----------*|*-----------*|*--------------*|*--------------*|
| spine01  | leaf01  | 10204       | 10402       | Ethernet 0     | Ethernet 0     |
| spine01  | leaf01  | 11204       | 11402       | Ethernet 4     | Ethernet 4     |
| spine01  | leaf02  | 10205       | 10502       | Ethernet 8     | Ethernet 8     |
| spine01  | leaf02  | 11205       | 11502       | Ethernet 12    | Ethernet 12    |
| spine02  | leaf02  | 10305       | 10503       | Ethernet 0     | Ethernet 0     |
| spine02  | leaf02  | 11305       | 11503       | Ethernet 4     | Ethernet 4     |
| spine02  | leaf01  | 10304       | 10403       | Ethernet 8     | Ethernet 8     |
| spine02  | leaf01  | 11304       | 11403       | Ethernet 12    | Ethernet 12    |

