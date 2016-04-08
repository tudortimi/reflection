#!/bin/env bash

args=`getopt -o t: --long test: -n "$0" -- "$@"`
eval set -- "$args"


t_arg=""

while true ; do
    case "$1" in
        -t|--test)
            t_arg="-t $2"
	    shift 2
	    ;;
        --)
	    shift
	    break
	    ;;
        *)
	    echo "Internal error!"
	    exit 1
	    ;;
    esac
done


runSVUnit \
    -s ius \
    -o tmp \
    -f reflection.f \
    $t_arg
