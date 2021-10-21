# !/bin/bash
INPUT=../crime_data/for_sentencepiece/all_aggregate.txt
MODEL_DIR=../models/sentencepiece

mkdir -p ${MODEL_DIR}
spm_train --input=${INPUT} \
    --model_prefix=${MODEL_DIR}/law.sentencepiece \
    --vocab_size=8000 \
    --character_coverage=0.995 \
    --model_type=bpe