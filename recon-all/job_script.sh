#!/bin/sh
#OAR -p mem_core>8000
#OAR -l core=1,walltime=30:00:00
#OAR -O /home/ssilvari/logs/%jobid%.output
#OAR -E /home/ssilvari/logs/%jobid%.error

FSDIR='/data/epione/user/ssilvari/RAW_DATASETS/ABIDE-I_FS'

recon-all -i $1 -s $2 -sd "${FSDIR}" -all
#recon-all -i $1 -s $2 -sd "/dev/shm" -all
#
#pid=$!
#wait ${pid}
#
#eval "mv /dev/shm/$2 ${FSDIR}"
