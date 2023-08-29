#!/usr/bin/env bash

# The port for communication. Note that if you want to run multiple tasks on the same machine,
# you need to specify different port numbers.

user_dir=../../ofa_module
bpe_dir=../../utils/BPE

data=/research/ktimes/data/preprocessed/test.tsv
path=/research/OFA/run_scripts/keyword_extraction/ofa_3_task_pretrained_checkpoints/6_1e-5_0.2/checkpoint_best.pt
result_path=/research/OFA/results/keyword_extraction/3_task_pretrained
selected_cols=0,1,4
split='test'

python ../../evaluate.py \
    ${data} \
    --path=${path} \
    --user-dir=${user_dir} \
    --task=keyword_extraction \
    --batch-size=8 \
    --log-format=simple --log-interval=10 \
    --seed=7 \
    --gen-subset=${split} \
    --results-path=${result_path} \
    --beam=6 \
    --lenpen=0.7 \
    --max-len-b=32 \
    --no-repeat-ngram-size=3 \
    --fp16 \
    --num-workers=0 \
    --model-overrides="{\"data\":\"${data}\",\"bpe_dir\":\"${bpe_dir}\",\"selected_cols\":\"${selected_cols}\"}"

# python3 eval_rouge.py ${result_path}/test_predict.json
