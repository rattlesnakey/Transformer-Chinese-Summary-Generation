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
    --seed 42 \


    # --patience 10
    # --max-tokens 4096
    # --max-update 200000
