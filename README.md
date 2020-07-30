# nagios-mibs
Finding SNMP MIBS and their dependencies used by Nagios

Filters out unused MIBs that allows Nagios use much less resources.
One day I noticed that Nagios was using too much CPU and memory when doing its checks. The reason was that before that I had downloaded a large package of MIB from the equipment vendor and used some of the OIDs from there. And all these MIBs were processed every time, every check of Nagios by the system SNMP utilities.

* ```findmibdep.sh``` recursively runs and searches for MIB dependencies for the specified MIB
* ```nagios-mibs.sh``` parses Nagios configuration files, looks for OIDs in them, extracts the names of the MIB, copies all used MIBs and their dependencies to the system folder for the SNMP MIB.
