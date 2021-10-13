# ! /bin/bash
set -e

DATA_DIR=../crime_data/for_fairseq/data-bin
MODEL_DIR=../models
OUTPUT_PATH=../results/beam5-result
if [ ! -d ${OUTPUT_PATH} ]; then 
    mkdir -p ${OUTPUT_PATH}
fi

CUDA_VISIBLE_DEVICES=4 fairseq-generate ${DATA_DIR} \
    --path ${MODEL_DIR}/checkpoints/checkpoint68.pt \
    --batch-size 16 --beam 5 --remove-bpe \
    --results-path ${OUTPUT_PATH} \
    --skip-invalid-size-inputs-valid-test

python -u ../src/calculate_rouge.py --input ${OUTPUT_PATH}/generate-test.txt