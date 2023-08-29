#!/usr/bin/env

# The port for communication. Note that if you want to run multiple tasks on the same machine,
# you need to specify different port numbers.
export MASTER_PORT=1052

log_dir=./huge_ofa_train_1/stage2_logs
save_dir=./huge_ofa_train_1/stage2_checkpoints
mkdir -p $log_dir $save_dir

bpe_dir=../../utils/BPE
user_dir=../../ofa_module

data_dir=../../dataset/context_caption_data
data=${data_dir}/train.tsv,${data_dir}/val.tsv
restore_file=path=/research/OFA/run_scripts/context_caption/huge_ofa_train/stage1_checkpoints/5_0.06_2500/checkpoint_best.pt
selected_cols=0,1,2,3

task=context_caption
arch=ofa_huge
criterion=scst_reward_criterion
label_smoothing=0.1
lr=1e-5
max_epoch=5
warmup_ratio=0.06
batch_size=4
update_freq=16
resnet_drop_path_rate=0.0
encoder_drop_path_rate=0.0
decoder_drop_path_rate=0.0
dropout=0.0
attention_dropout=0.0
max_src_length=256
max_tgt_length=30
num_bins=1000
patch_image_size=480
eval_cider_cached=${data_dir}/cider_cached_tokens/valid-words.p
scst_cider_cached=${data_dir}/cider_cached_tokens/train-words.p

# for lr in {1e-5,}; do
#   echo "lr "${lr}
#   for max_epoch in {3,}; do
#     echo "max_epoch "${max_epoch}

    log_file=${log_dir}/${lr}"_"${max_epoch}"scst.log"
    save_path=${save_dir}/${lr}"_"${max_epoch}
    mkdir -p $save_path

     python3 ../../train.py \
        $data \
        --selected-cols=${selected_cols} \
        --bpe-dir=${bpe_dir} \
        --user-dir=${user_dir} \
        --restore-file=${restore_file} \
        --reset-optimizer --reset-dataloader --reset-meters \
        --save-dir=${save_path} \
        --task=${task} \
        --arch=${arch} \
        --criterion=${criterion} \
        --batch-size=${batch_size} \
        --update-freq=${update_freq} \
        --encoder-normalize-before \
        --decoder-normalize-before \
        --share-decoder-input-output-embed \
        --share-all-embeddings \
        --layernorm-embedding \
        --patch-layernorm-embedding \
        --code-layernorm-embedding \
        --resnet-drop-path-rate=${resnet_drop_path_rate} \
        --encoder-drop-path-rate=${encoder_drop_path_rate} \
        --decoder-drop-path-rate=${decoder_drop_path_rate} \
        --dropout=${dropout} \
        --attention-dropout=${attention_dropout} \
        --weight-decay=0.01 --optimizer=adam --adam-betas="(0.9,0.999)" --adam-eps=1e-08 --clip-norm=1.0 \
        --lr-scheduler=polynomial_decay --lr=${lr} --end-learning-rate=2e-7 \
        --max-epoch=${max_epoch} --warmup-ratio=${warmup_ratio} \
        --log-format=simple --log-interval=10 \
        --fixed-validation-seed=7 \
        --no-epoch-checkpoints --keep-best-checkpoints=1 \
        --save-interval=1 --validate-interval=1 \
        --save-interval-updates=5000 --validate-interval-updates=5000 \
        --eval-cider \
        --eval-cider-cached-tokens=${eval_cider_cached} \
        --eval-args='{"beam":5,"max_len_b":16,"no_repeat_ngram_size":3}' \
        --best-checkpoint-metric=cider --maximize-best-checkpoint-metric \
        --max-src-length=${max_src_length} \
        --max-tgt-length=${max_tgt_length} \
        --find-unused-parameters \
        --freeze-encoder-embedding \
        --freeze-decoder-embedding \
        --add-type-embedding \
        --scale-attn \
        --scale-fc \
        --scale-heads \
        --disable-entangle \
        --num-bins=${num_bins} \
        --patch-image-size=${patch_image_size} \
        --scst \
        --scst-cider-cached-tokens=${scst_cider_cached} \
        --scst-args='{"beam":5,"max_len_b":16,"no_repeat_ngram_size":3}' \
        --memory-efficient-fp16 \
        --fp16-scale-window=512 \
        --num-workers=0 > ${log_file} 2>&1
#   done
# done