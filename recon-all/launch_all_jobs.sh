#!/bin/sh

RAW_DATA_FOLDER="/data/epione/user/ssilvari/RAW_DATASETS/ABIDE-I"
SUBJECTS_DIR='/data/epione/user/ssilvari/RAW_DATASETS/ABIDE-I_FS'

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for path in $(find "${RAW_DATA_FOLDER}"  -name "*.nii.gz")
do
  # Extract Subject ID from image SID.nii.gz
  sid=$(basename "${path}" | awk -F "." '{ print $1 }')
  subject_dir="$SUBJECTS_DIR/$sid"

  # Check if directory does not exist. If it does, skip the job launching (less karma)
	if [[ ! -d $subject_dir ]]
	then
	  echo "Launching job for subject ${sid}"
		oarsub -S "${CURRENT_DIR}/cross_job.sh $path $sid"
  else
    echo "Subject in folder ${subject_dir} was already processed."
	fi

  # Limit the number of jobs to 500
	n_jobs=$(oarstat -u | wc -l)
	while [ "${n_jobs}" -gt 500 ]
	do
		sleep 1m
		n_jobs=$(oarstat -u | wc -l)
	done
done
