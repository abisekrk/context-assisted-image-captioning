#!/usr/bin/env bash

# The port for communication. Note that if you want to run multiple tasks on the same machine,
# you need to specify different port numbers.
export MASTER_PORT=7081

user_dir=../../ofa_module
bpe_dir=../../utils/BPE

# dev or test
split=$1

data=../../dataset/consistency_detection/test.tsv
path=../../checkpoints/ofa_large.pt
result_path=../../results/consistency_detection
selected_cols=0,1,2,3,4

task=consistency_detection

python ../../evaluate.py \
    ${data} \
    --path=${path} \
    --user-dir=${user_dir} \
    --task=${task} \
    --batch-size=4 \
    --log-format=simple --log-interval=10 \
    --seed=7 \
    --gen-subset=${split} \
    --results-path=${result_path} \
    --fp16 \
    --num-workers=0 \
    --model-overrides="{\"data\":\"${data}\",\"bpe_dir\":\"${bpe_dir}\",\"selected_cols\":\"${selected_cols}\"}"