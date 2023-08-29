#!/usr/bin/env bash

# The port for communication. Note that if you want to run multiple tasks on the same machine,
# you need to specify different port numbers.
export MASTER_PORT=1081
export CUDA_VISIBLE_DEVICES=0
export GPUS_PER_NODE=8

user_dir=../../ofa_module
bpe_dir=../../utils/BPE

data_dir=../../dataset/context_caption_data
data=../../dataset/context_caption_data/val.tsv
path=/home/development/abisekrk/Research/OFA/run_scripts/context_caption/stage1_checkpoints/5_0.06_2500/checkpoint.best_cider_0.5530.pt
result_path=../../results/context_caption/valid
selected_cols=0,1,2,3
split='test'

CUDA_VISIBLE_DEVICES=1 python3  ../../evaluate.py \
    ${data} \
    --path=${path} \
    --user-dir=${user_dir} \
    --task=context_caption \
    --batch-size=2 \
    --log-format=simple --log-interval=10 \
    --seed=7 \
    --gen-subset=${split} \
    --results-path=${result_path} \
    --beam=5 \
    --max-len-b=16 \
    --no-repeat-ngram-size=3 \
    --fp16 \
    --num-workers=0 \
    --model-overrides="{\"data\":\"${data}\",\"bpe_dir\":\"${bpe_dir}\",\"eval_cider\":False,\"selected_cols\":\"${selected_cols}\"}"

python coco_eval.py ../../results/context_caption/valid/test_predict.json /home/development/abisekrk/Research/OFA/dataset/context_caption_data/coco_format/val.json
# python coco_eval.py ../../results/context_caption/test_predict.json /home/development/abisekrk/Research/OFA/dataset/context_caption_data/coco_format/test.json

# python coco_eval.py ../../results/context_caption/sample_test_predict.json /home/development/abisekrk/Research/OFA/dataset/context_caption_data/coco_format/sample_test.json