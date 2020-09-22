#!/bin/sh

export SUBJECTS_DIR='/data/epione/user/ssilvari/RAW_DATASETS/ABIDE-I_FS'
export MEDIAL_DEMONS_DIR="/home/ssilvari/Apps/MedialDemonsShared"

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for path in $(find "${SUBJECTS_DIR}"  -name "aseg.mgz")
do
  # Extract Subject ID from image SID.nii.gz
  sid=$(echo "${path}" | awk -F/ '{print $(NF-2)}')
  results_directory="$SUBJECTS_DIR/$sid/shapes"

  # Check if directory does not exist. If it does, skip the job launching (less karma)
	if [[ ! -d $results_directory ]]
	then
	  echo "Launching job for subject ${sid}"
	  oarsub -S "bash -c \"export SUBJECTS_DIR=${SUBJECTS_DIR} && ${CURRENT_DIR}/enigma-shape.sh ${sid}\""
  else
    echo "Subject in folder ${results_directory} was already processed."
	fi

  # Limit the number of jobs to 500
	n_jobs=$(oarstat -u | wc -l)
	while [ "${n_jobs}" -gt 500 ]
	do
		sleep 1m
		n_jobs=$(oarstat -u | wc -l)
	done
done
