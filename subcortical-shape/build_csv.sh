#!/bin/sh

export ESHAPE_DIR='/data/epione/user/ssilvari/RAW_DATASETS/ABIDE_SHAPE'
export MEDIAL_DEMONS_DIR="/home/ssilvari/Apps/MedialDemonsShared"

ROIS="10 11 12 13 17 18 26 49 50 51 52 53 54 58"
GROUPFILE="${ESHAPE_DIR}/groupfile.csv"

CMD="${MEDIAL_DEMONS_DIR}/bin/raw_list2CSV_matrix ${ESHAPE_DIR}/LogJacs.csv ${MEDIAL_DEMONS_DIR}/atlas GOF ${ROIS} LogJacs resliced_mesh ${GROUPFILE} ${ESHAPE_DIR}"
echo "${CMD}"
eval "${CMD}"

CMD="${MEDIAL_DEMONS_DIR}/bin/raw_list2CSV_matrix ${ESHAPE_DIR}/thick.csv ${MEDIAL_DEMONS_DIR}/atlas GOF ${ROIS} thick resliced_mesh ${GROUPFILE} ${ESHAPE_DIR}"
echo "${CMD}"
eval "${CMD}"
