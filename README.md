# Transformer-Chinese-Summary-Generation
> The dataset is base on crime field

# File Structure
```markdown
├── crime_data
│   ├── for_fairseq
│   ├── for_sentencepiece
│   └── origin
├── environment.yaml
├── models
│   ├── checkpoints
│   └── sentencepiece
├── README.md
├── requirements.txt
├── results
│   └── beam5-result
├── scripts
│   ├── evaluate.sh
│   ├── interact.sh
│   ├── prepare_for_fairseq.sh
│   ├── prepare_for_sentencepiece.sh
│   ├── train_sentencepiece_model.sh
│   └── train.sh
└── src
    ├── calculate_rouge.py
    └── process.py
```

# Setup
## Install SentencePiece
>refer to this [blog](https://www.jianshu.com/p/d36c3e06fb98)

## Create Virtual Environment
### Conda
`conda env create -f environment.yaml`
### Pip
`pip install -r requirements.txt`


# Run
## Prepare data for training SentencePiece
```shell
cd scripts
bash prepare_for_sentencepiece.sh
```

```shell
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
```
* all_aggregate.txt is the file that aggregate train, dev, test dataset into. It is pure text, not include any label.

### orign/train.json sample
```
{"document": "原告吴国锋与被告上海易初莲花连锁超市有限公司(以下至判决主文前简称易初莲花公司)劳动合同纠纷一案，因双方不服同一仲裁裁决，吴国锋向本院提起诉讼，易初莲花公司向上海市第二中级人民法院申请撤销仲裁裁决。原告吴国锋向本院提出诉讼请求，请求判令被告支付：1、2016年11月至2017年1月工资差额人民币1,500元(以下币种均为人民币)；2、解除劳动合同经济补偿金44,942元。被告易初莲花公司向本院提出诉讼请求，请求判令不支付吴国锋2016年11月至2017年1月工资差额2,000元。本院认为，本案的争议焦点为二项：第一，莲源公司作出的通知以及三方签订的用工主体变更协议书是否对易初莲花公司有效；第二，吴国锋在莲源公司工作期间“其他小计”项费用的性质。故本院认为“其他小计”项费用并非吴国锋的固定工资组成部分。关于2016年11月至2017年1月工资差额1,500元,根据查明事实，莲源公司支付的该笔费用为驾驶高危险性操作员工特别申请的费用，吴国锋在易初莲花公司处驾驶的叉车与在莲源公司处驾驶的叉车确有不同，危险性亦有差异，故本院认为易初莲花公司无需支付该笔费用。本案中，易初莲花公司未支付吴国锋在莲源公司工作期间的“其他小计”费用，系因吴国锋驾驶叉车类别发生变化，且该笔费用是否属固定工资组成部分双方亦存有争议而引起，本院难以认定易初莲花公司系因主观恶意而拒绝支付吴国锋劳动报酬。故对吴国锋要求易初莲花公司支付解除劳动经济补偿金的请求本院难以支持。综上所述，依照《中华人民共和国劳动合同法》第三十条第一款、三十八条第二项、四十六条第一项规定，判决如下：一、被告上海易初莲花连锁超市有限公司无需支付原告吴国锋2016年11月至2017年2月工资差额2,000元；二、驳回原告吴国锋的诉讼请求。", "summary": "原被告系劳动合同纠纷。原告诉求：被告支付工资差额、解除劳动合同经济补偿金。被告诉求不支付吴国锋工资差额。本案的争议焦点为：被告作出的通知以及三方签订的用工主体变更协议书是否对被告有效；原告在被告处期间“其他小计”项费用的性质。经法院查明：“其他小计”项费用并非原告的固定工资组成部分，被告未支付原告在被告“其他小计”费用系因原告驾驶叉车类别发生变化，故被告无需支付工资差额。同时难以认定被告系因主观恶意而拒绝支付吴国锋劳动报酬，吴国锋要求易初莲花公司支付解除劳动经济补偿金的请求本院难以支持。依照《劳动合同法》第三十条、三十八条、四十六条规定，判决被告无需支付原告工资差额；驳回原告的诉讼请求。"}

{"document": "原告郭丽丽与被告渝中区正宇商贸行（以下简称正宇商贸行）劳动合同纠纷一案，本院于2017年10月12日立案后，经审理发现有不宜适用简易程序的情形，依法裁定转换为普通程序，公开开庭进行了审理。原告郭丽丽向本院提出诉讼请求：判决被告向原告支付2017年8月1日至8月31日未签书面劳动合同的二倍工资差额2500元。原告在被告处工作超过一个月不满一年，劳动关系存续期间，被告未给原告签订书面劳动合同，根据上述法律规定，除正常工资外，被告还应当支付原告2017年7月23日至8月31日期间的二倍工资差额，原告只主张2017年8月1日至8月31日期间的二倍工资差额，系对其权利的自由处分，本院予以照准。依照《中华人民共和国劳动合同法》第七条、第八十二条第一款以及《中华人民共和国民事诉讼法》第一百四十四条之规定，判决如下：被告渝中区正宇商贸行在本判决生效后立即向原告郭丽丽支付2017年8月1日至8月31日期间未签订书面劳动合同的二倍工资差额2500元。如果未按本判决指定的期间履行给付金钱义务，应当依照《中华人民共和国民事诉讼法》第二百五十三条之规定，加倍支付迟延履行期间的债务利息。", "summary": "原告与被告劳动合同纠纷一案。原告提出诉求：判决被告向原告支付未签书面劳动合同的二倍工资差额。由于原告在被告处工作超过一个月不满一年，劳动关系存续期间，被告未给原告签订书面劳动合同，根据《中华人民共和国劳动合同法》第七条、第八十二条第一款以及《中华人民共和国民事诉讼法》第一百四十四条，判决被告在本判决生效后立即向原告支付未签订书面劳动合同的二倍工资差额。如未按本判决指定期间履行给付金钱义务，依照《中华人民共和国民事诉讼法》第二百五十三条规定，加倍支付迟延履行期间的债务利息。"}

{"document": "原告郝朋明与被告长春市万利驾驶员培训有限责任公司劳动合同纠纷一案，本院于2017年3月20日立案后，依法适用普通程序，开庭进行了审理。郝朋明向本院提出诉讼请求：1.判决被告给付原告工资16500元整。长春市万利驾驶员培训有限责任公司辩称，答辩人将基隆街场地项目整体外包给承包方郝伟，实际施工人郝伟已承认其为场地项目的承包人，并且双方至今未验收，答辩人已将全部施工款分多笔全部转至其名下账户中，合计人民币376，000元。答辩人与被答辩人无劳动关系、无雇佣关系，未签订过任何协议，未办理过任何手续，未产生过任何法律关系。依照《中华人民共和国民法通则》第五条，《中华人民共和国民事诉讼法》第六十四条的规定，判决如下：驳回原告郝朋明的诉讼请求。", "summary": "原告与被告劳动合同纠纷一案。原告提出诉求：判决被告给付原告工资。被告抗辩：答辩人项目整体外包给承包方，实际施工人案外人已承认其为承包人，并且双方至今未验收，答辩人已将全部施工款分多笔全部转至其账户中，答辩人与被答辩人无劳动关系、无雇佣关系，未签订过任何协议，未办理过任何手续，未产生过任何法律关系。由于案外人因承包被告的施工项目，雇佣原告提供劳务活动，原告与案外人发生雇佣合同关系；现原告主张与被告发生劳动关系并请求被告支付工资，但不能提供双方存在劳动关系的证据予以证明，应当承担举证不能的责任，根据《中华人民共和国民法通则》第五条，《中华人民共和国民事诉讼法》第六十四条，判决驳回原告的诉讼请求。"}
```
### all_aggregate.txt data sample
```markdown
原被告系劳动合同纠纷。原告诉求：被告支付工资差额、解除劳动合同经济补偿金。被告诉求不支付吴国锋工资差额。本案的争议焦点为：被告作出的通知以及三方签订的用工主体变更协议书是否对被告有效；原告在被告处期间“其他小计”项费用的性质。经法院查明：“其他小计”项费用并非原告的固定工资组成部分，被告未支付原告在被告“其他小计”费用系因原告驾驶叉车类别发生变化，故被告无需支付工资差额。同时难以认定被告系因主观恶意而拒绝支付吴国锋劳动报酬，吴国锋要求易初莲花公司支付解除劳动经济补偿金的请求本院难以支持。依照《劳动合同法》第三十条、三十八条、四十六条规定，判决被告无需支付原告工资差额；驳回原告的诉讼请求。
原告郭丽丽与被告渝中区正宇商贸行（以下简称正宇商贸行）劳动合同纠纷一案，本院于2017年10月12日立案后，经审理发现有不宜适用简易程序的情形，依法裁定转换为普通程序，公开开庭进行了审理。原告郭丽丽向本院提出诉讼请求：判决被告向原告支付2017年8月1日至8月31日未签书面劳动合同的二倍工资差额2500元。原告在被告处工作超过一个月不满一年，劳动关系存续期间，被告未给原告签订书面劳动合同，根据上述法律规定，除正常工资外，被告还应当支付原告2017年7月23日至8月31日期间的二倍工资差额，原告只主张2017年8月1日至8月31日期间的二倍工资差额，系对其权利的自由处分，本院予以照准。依照《中华人民共和国劳动合同法》第七条、第八十二条第一款以及《中华人民共和国民事诉讼法》第一百四十四条之规定，判决如下：被告渝中区正宇商贸行在本判决生效后立即向原告郭丽丽支付2017年8月1日至8月31日期间未签订书面劳动合同的二倍工资差额2500元。如果未按本判决指定的期间履行给付金钱义务，应当依照《中华人民共和国民事诉讼法》第二百五十三条之规定，加倍支付迟延履行期间的债务利息。
原告与被告劳动合同纠纷一案。原告提出诉求：判决被告向原告支付未签书面劳动合同的二倍工资差额。由于原告在被告处工作超过一个月不满一年，劳动关系存续期间，被告未给原告签订书面劳动合同，根据《中华人民共和国劳动合同法》第七条、第八十二条第一款以及《中华人民共和国民事诉讼法》第一百四十四条，判决被告在本判决生效后立即向原告支付未签订书面劳动合同的二倍工资差额。如未按本判决指定期间履行给付金钱义务，依照《中华人民共和国民事诉讼法》第二百五十三条规定，加倍支付迟延履行期间的债务利息。
原告郝朋明与被告长春市万利驾驶员培训有限责任公司劳动合同纠纷一案，本院于2017年3月20日立案后，依法适用普通程序，开庭进行了审理。郝朋明向本院提出诉讼请求：1.判决被告给付原告工资16500元整。长春市万利驾驶员培训有限责任公司辩称，答辩人将基隆街场地项目整体外包给承包方郝伟，实际施工人郝伟已承认其为场地项目的承包人，并且双方至今未验收，答辩人已将全部施工款分多笔全部转至其名下账户中，合计人民币376，000元。答辩人与被答辩人无劳动关系、无雇佣关系，未签订过任何协议，未办理过任何手续，未产生过任何法律关系。依照《中华人民共和国民法通则》第五条，《中华人民共和国民事诉讼法》第六十四条的规定，判决如下：驳回原告郝朋明的诉讼请求。
```

## Train SentencePiece 
```shell
cd scripts
bash train_sentencepiece_model.sh
```

```shell
# !/bin/bash
INPUT=../crime_data/for_sentencepiece/all_aggregate.txt
MODEL_DIR=../models/sentencepiece

mkdir -p ${MODEL_DIR}
spm_train --input=${INPUT} \
    --model_prefix=${MODEL_DIR}/law.sentencepiece \
    --vocab_size=8000 \
    --character_coverage=0.995 \
    --model_type=bpe
```

## Preprocess data for Fairseq
> To generate .src & .tgt files, and binarize data
```shell
cd scripts
bash prepare_for_fairseq.sh
```

```shell
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
```

## Train model
```shell
cd scripts
bash train.sh
```

```shell
# ! /bin/bash
set -e
export MKL_THREADING_LAYER=GNU
DATA_DIR=../crime_data/for_fairseq/data-bin
MODEL_DIR=../models
WAND_RUN_NAME=lr1e-4-batch16
LR=0.0001
BATCH_SIZE=8
ACCU_GRADIENT=2
CUDA_VISIBLE_DEVICES=1 WANDB_NAME=${WAND_RUN_NAME} fairseq-train ${DATA_DIR} --arch transformer \
	--source-lang src --target-lang tgt  \
    --optimizer adam  --lr ${LR} --adam-betas '(0.9, 0.98)' \
    --lr-scheduler inverse_sqrt --dropout 0.3 \
    --criterion label_smoothed_cross_entropy  --label-smoothing 0.1 \
    --max-epoch 100 --batch-size ${BATCH_SIZE} --warmup-updates 4000 --warmup-init-lr '1e-07' \
    --update-freq 2 --task translation \
    --keep-last-epochs 5 --num-workers 8 \
	--save-dir ${MODEL_DIR}/checkpoints \
    --wandb-project summary-generation-transformer-fairseq \
    --best-checkpoint-metric loss --maximize-best-checkpoint-metric \
    --skip-invalid-size-inputs-valid-test \
    --seed 42 

```

## Evaluate on test
```shell
cd scripts
bash evaluate.sh
```

```shell
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
```

## Interact
```shell
cd scripts
bash interact.sh
```

```shell
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
```