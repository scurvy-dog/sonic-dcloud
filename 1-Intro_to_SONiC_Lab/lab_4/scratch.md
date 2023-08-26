
  <pre>
  leaf01# show bgp ipv4 uni
  BGP table version is 10, local router ID is 10.0.0.4, vrf id 0
  Default local pref 100, local AS 65004
  Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
  Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
  Origin codes:  i - IGP, e - EGP, ? - incomplete
  RPKI validation codes: V valid, I invalid, N Not found

     Network          Next Hop            Metric LocPrf Weight Path
  *> 10.0.0.2/32      10.1.1.1                 0             0 65000 i
  *> 10.0.0.3/32      10.1.1.3                 0             0 65000 i
  *> 10.0.0.4/32      0.0.0.0                  0         32768 i <b>
  *> 10.0.0.5/32      10.1.1.1                               0 65000 65005 i
  *=                  10.1.1.3                               0 65000 65005 i
</b>
  </pre>
