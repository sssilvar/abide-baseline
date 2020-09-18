#!/bin/sh
#OAR -p mem_core>8000
#OAR -l core=1,walltime=30:00:00
#OAR -O /home/ssilvari/logs/%jobid%.output
#OAR -E /home/ssilvari/logs/%jobid%.error

FSDIR='/data/epione/user/ssilvari/RAW_DATASETS/ABIDE-I_FS'

if [ -z "$1" ]; then
    echo "First argument needed: T1 input file."
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "File does not exist: ${1} ."
    exit 1
fi

if [ -z "$2" ]; then
    echo "Second argument needed: Subject ID"
    exit 1
fi

recon-all -i $1 -s $2 -sd "/dev/shm" -all

pid=$!
wait ${pid}

eval "mv /dev/shm/$2 ${FSDIR}"
