#!/bin/bash

# usage: findmibdep.sh <MIB>
# MIB - mib name, not filename
# returns MIB dependences recursive
# v1.0 20160201
# popov.ap@gmail.com


if [[ ! $1 ]]; then
    echo "No MIB passed"
    exit 2
fi

finddep () {
    for MIB in $1	       
    do
	local MATCHMIB=$(grep "^ *$MIB DEFINITIONS" *.*)
	if [[ -z $MATCHMIB ]]; then continue; fi
	local MIBFILE=$(echo "$MATCHMIB" | sed "s/^\(.*\..*\)\:.*$MIB.*$/\1/p" | uniq)
	if [[ ! -f $MIBFILE ]]; then
	    continue
	fi
	local MIBDEP=$(grep "FROM" $MIBFILE | sed -n 's/^.*FROM\ \(.*\)/\1/p' | sed 's/;//')
	if [[ -n $MIBDEP ]]; then
	    echo "$MIBDEP"
	    for i in $MIBDEP; do finddep $i; done
	fi
    done | sort -rn | uniq
}

finddep "$1"
