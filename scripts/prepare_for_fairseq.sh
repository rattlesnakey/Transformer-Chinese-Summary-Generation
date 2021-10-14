# !bin/zsh
set -v
set -e
ORIGIN_DATA_PREFIX=../crime_data/origin
PREPARE_DATA_PREFIX=../crime_data/for_fairseq/prepare
BPE_DIR=../crime_data/for_fairseq/bpe
BPE_MODEL=../models/sentencepiece/law.sentencepiece.model
BIN_DIR=../crime_data/for_fairseq/data-bin
# DICT=../models/sentencepiece/law.sentencepiece.vocab
for file in train dev test; do
    python -u ../src/process.py \
    --input ${ORIGIN_DATA_PREFIX}/${file}.json \
    --output ${PREPARE_DATA_PREFIX}/${file} \
    --task fairseq
    done

if [ -d ${BPE_DIR} ]; then
    rm -rf ${BPE_DIR}
fi

mkdir -p ${BPE_DIR}

for file in `ls ${PREPARE_DATA_PREFIX}`; do
    spm_encode --model=${BPE_MODEL} \
        < ${PREPARE_DATA_PREFIX}/${file} \
        > ${BPE_DIR}/${file}
    done

if [ -d ${BIN_DIR} ]; then 
    rm -rf ${BIN_DIR}
fi
fairseq-preprocess \
    --source-lang src \
    --target-lang tgt \
    --trainpref ${BPE_DIR}/train \
    --validpref ${BPE_DIR}/dev \
    --testpref ${BPE_DIR}/test \
    --destdir ${BIN_DIR} \
    --workers 20