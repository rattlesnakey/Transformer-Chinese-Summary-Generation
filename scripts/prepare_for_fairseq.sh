# !bin/zsh
set -v
set -e
ORIGIN_DATA_PREFIX=../crime_data/origin
PREPARE_DATA_PREFIX=../crime_data/for_fairseq/prepare
BPE_DIR=../crime_data/for_fairseq/bpe
BPE_MODEL=../../fairseq-bart/pretrained-models # 改
BIN_DIR=../crime_data/for_fairseq/data-bin
DICT=pretrained-models/mbart.cc25.v2/dict.txt # 改
for file in train dev test; do
    python -u ../src/process.py --input ${ORIGIN_DATA_PREFIX}/${file}.json --output ${PREPARE_DATA_PREFIX}/${file}
    done

if [ -d ${BPE_DIR} ]; then
    rm -rf ${BPE_DIR}
fi

mkdir -p ${BPE_DIR}

for file in `ls ${PREPARE_DATA_PREFIX}`; do
    spm_encode --model=${BPE_MODEL} \
        < ${PREPARE_DATA_PREFIX}/${file} \
        > ${BPE_DIR}/${file}


fairseq-preprocess \
    --source-lang src \
    --target-lang tgt \
    --trainpref ${BPE_DIR}/train \
    --validpref ${BPE_DIR}/valid \
    --testpref ${BPE_DIR}/test \
    --destdir ${BIN_DIR} \
    --srcdict ${DICT} \
    --tgtdict ${DICT} \
    --workers 20