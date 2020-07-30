#!/bin/bash

# v1.0 20160201
# find MIBs used in Nagios configs and copy them with dependences to specified dir
# Before run you need to be located in MIB dir
# popov.ap@gmail.com

# TODO: CISCO-ENVMON-MIB escaped from filtering last time

NAGIOSMIBS=$(find /etc/nagios3/objects -iname "*.cfg" -exec grep "\-o" {} \; | sed -n 's/^.*\-o\ \(.*\)\:\:.*$/\1/p' | sort -rn | uniq)

finddep () {
    for MIB in $1	       
    do
	local MATCHMIB=$(grep "^ *$MIB DEFINITIONS" *.*)
	if [[ -z $MATCHMIB ]]; then continue; fi
	local MIBFILE=$(echo "$MATCHMIB" | sed "s/^\(.*\..*\)\:.*$MIB.*$/\1/p" | uniq)
	if [[ ! -f $MIBFILE ]]; then continue; fi
	local MIBDEP=$(grep "FROM" $MIBFILE | sed -n 's/^.*FROM\ \(.*\)/\1/p' | sed 's/;//')
	if [[ -n $MIBDEP ]]; then
	    echo "$MIBDEP"
	    for i in $MIBDEP; do finddep $i; done
	fi
    done | sort -rn | uniq
}

DEPS=$(finddep "$NAGIOSMIBS")
ALLMIBS=$(echo "$NAGIOSMIBS$DEPS" | sort -rn | uniq)

#echo "$ALLMIBS"

copymib () {
    for j in $1; do
	local MATCHMIB=$(grep "^ *$j DEFINITIONS" *.*)
	if [[ -z $MATCHMIB ]]; then continue; fi
	local MIBFILE=$(echo "$MATCHMIB" | sed "s/^\(.*\..*\)\:.*$j.*$/\1/p" | uniq)
	if [[ -n $MIBFILE ]]; then
	    cp $MIBFILE /usr/local/share/snmp/mibs/NagiosMIBS/
	fi
    done
}

copymib "$ALLMIBS"
