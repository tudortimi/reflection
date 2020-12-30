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

../gradlew --project-dir .. writeSvunitDirPath genFullArgsFile

svunit_dir=$(head -n 1 ../build/svunit_dir_path.txt)
echo "Using SVUnit from $svunit_dir"
cd $svunit_dir
source Setup.bsh
cd - > /dev/null

runSVUnit \
    -s ius \
    -o tmp \
    -f ../build/full_args.f \
    $t_arg
