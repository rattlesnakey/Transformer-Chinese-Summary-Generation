# ! /bin/bash
set -e

MODEL_DIR=../models
OUTPUT_PATH=../results/interactive
DATA_DIR=../crime_data/for_fairseq/data-bin
CUDA_VISIBLE_DEVICES=4 fairseq-interactive ${DATA_DIR} \
    --path ${MODEL_DIR}/checkpoints/checkpoint68.pt \
    --beam 5 --remove-bpe \
    --results-path ${OUTPUT_PATH} \
    --skip-invalid-size-inputs-valid-test