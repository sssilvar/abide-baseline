#!/bin/sh
#OAR -p mem_core>8000
#OAR -l core=1,walltime=2:00:00
#OAR -O /home/ssilvari/logs/%jobid%.output
#OAR -E /home/ssilvari/logs/%jobid%.error

MEDIAL_DEMONS_DIR=${MEDIAL_DEMONS_DIR:="/home/ssilvari/Apps/MedialDemonsShared"}
SUBJECT_ID=$1

if [ -z "$SUBJECT_ID" ]; then
    echo "First argument needed: Subject ID has not been provided."
    exit 1
fi

# perl MedialDemonsShared/bin/Medial_Demons_shared.pl /local/freesurfer/subjects/bert/mri/aseg.mgz 26 58 /home/ssilvari/Downloads/shape MedialDemonsShared/ /local/freesurfer/bin
ROIS="10 11 12 13 17 18 26 49 50 51 52 53 54 58"
SUBJECT_FOLDER="${SUBJECTS_DIR}/${SUBJECT_ID}"

echo "Extracting subcortical shape features from subject ${SUBJECT_ID}:"

if [ ! -d "${SUBJECT_FOLDER}" ]; then
    echo "Subject folder does not exist: ${SUBJECT_FOLDER}" 1>&2
    exit 64
fi

exit

CMD="perl ${MEDIAL_DEMONS_DIR}/bin/Medial_Demons_shared.pl ${SUBJECT_FOLDER}/mri/aseg.mgz ${ROIS} ${SUBJECT_FOLDER}/shapes ${MEDIAL_DEMONS_DIR} ${FREESURFER_HOME}/bin"
echo "${CMD}"
eval "${CMD}"