#!/usr/bin/env bash
DATA="shop"
loss="bin"
checkpoints="/opt/intern/users/xunwang/checkpoints"
r="_model.pkl"

mkdir $checkpoints
mkdir $checkpoints/$loss/
mkdir $checkpoints/$loss/$DATA/

mkdir result/
mkdir result/$loss/
mkdir result/$loss/$DATA/

DIM_list="512"
for DIM in $DIM_list;do
    l=$checkpoints/$loss/$DATA/$DIM
    mkdir $checkpoints/$loss/$DATA/$DIM
    CUDA_VISIBLE_DEVICES=2   python train.py -data $DATA  -net vgg  -init random  -lr 1e-5 -dim $DIM -alpha 40 -num_instances 5 -BatchSize 70 -loss $loss  -epochs 181 -step_1 100 -checkpoints $checkpoints  -log_dir $l -save_step 5
    Model_LIST="80 100 120 140 160 180"
    for i in $Model_LIST; do
        CUDA_VISIBLE_DEVICES=2  python test.py -data $DATA -r $l/$i$r >>result/$loss/$DATA/$DIM-.txt
        CUDA_VISIBLE_DEVICES=2  python pool_test.py -data $DATA -r $l/$i$r >>result/$loss/$DATA/$DIM--pool.txt
    done
done
