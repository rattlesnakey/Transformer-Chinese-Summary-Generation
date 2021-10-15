# !bin/zsh
set -v
set -e
ORIGIN_DATA_PREFIX=../crime_data/origin
PREPARE_DATA_PREFIX=../crime_data/for_sentencepiece/prepare
FINAL=../crime_data/for_sentencepiece/all_aggregate.txt

for file in train valid test; do
    python -u ../src/process.py --input ${ORIGIN_DATA_PREFIX}/${file}.json --output ${PREPARE_DATA_PREFIX}/${file}_aggregate.txt
    done

if [ -f ${FINAL} ]; then
    rm ${myFile}
fi

touch ${FINAL}
for each_file in `ls ${PREPARE_DATA_PREFIX}`; do
    cat ${PREPARE_DATA_PREFIX}/${each_file} >> ${FINAL}
    done 