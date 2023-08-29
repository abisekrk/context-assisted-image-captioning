#!/usr/bin/env bash

# The port for communication. Note that if you want to run multiple tasks on the same machine,
# you need to specify different port numbers.


user_dir=../../ofa_module
bpe_dir=../../utils/BPE

data_dir=../../dataset/context_caption_data
data=../../dataset/context_caption_data/test.tsv
path=/research/OFA/run_scripts/context_caption/large_1_task_cap/checkpoints/30_0.06_2500/checkpoint_best.pt
result_path=/research/OFA/results/context_caption/large_1_task/caption
selected_cols=0,1,2,3
split='test'

python ../../evaluate.py \
    ${data} \
    --path=${path} \
    --user-dir=${user_dir} \
    --task=context_caption_ne \
    --batch-size=16 \
    --log-format=simple --log-interval=10 \
    --seed=7 \
    --gen-subset=${split} \
    --results-path=${result_path} \
    --beam=10 \
    --max-len-b=30 \
    --temperature=0.98 \
    --lenpen=0.98 \
    --no-repeat-ngram-size=3 \
    --fp16 \
    --num-workers=0 \
    --model-overrides="{\"data\":\"${data}\",\"bpe_dir\":\"${bpe_dir}\",\"eval_cider\":False,\"selected_cols\":\"${selected_cols}\"}"

# python coco_eval.py ../../results/caption/test_predict.json ../../dataset/caption_data/test_caption_coco_format.json
