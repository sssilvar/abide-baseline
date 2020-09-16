#!/bin/sh
#OAR -p mem_core>8000
#OAR -l core=1,walltime=30:00:00
#OAR -O /home/ssilvari/logs/%jobid%.output
#OAR -E /home/ssilvari/logs/%jobid%.error

FSDIR='/data/epione/user/ssilvari/RAW_DATASETS/ABIDE-I_FS'

recon-all -s $2 -i $1 -sd "/dev/shm" -all
eval "mv /dev/shm/$2 ${FSDIR}"
