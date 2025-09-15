#!/bin/bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
source /usr/local/Ascend/nnal/atb/set_env.sh

export CUDA_DEVICE_MAX_CONNECTIONS=1
export PYTORCH_NPU_ALLOC_CONF=expandable_segments:True
export HCCL_CONNECT_TIMEOUT=3600
export HCCL_IF_BASE_PORT=28999
export CPU_AFFINITY_CONF=1
export HCCL_EXEC_TIMEOUT=2400
export TASK_QUEUE_ENABLE=2
export TORCHELASTIC_EXIT_BARRIER_TIMEOUT=2400
# export HCCL_SOCKET_IFNAME=eno0 # 若使用的不是默认网口，请指定为实际的网口
# export GLOO_SOCKET_IFNAME=eno0 # 若使用的不是默认网口，请指定为实际的网口

NPUS_PER_NODE=8
MASTER_ADDR=127.0.0.1 # 配置你的主节点IP
MASTER_PORT=6000
NNODES=8
NODE_RANK=0 # 配置你的节点rank
WORLD_SIZE=$(($NPUS_PER_NODE*$NNODES))

# 请配置实际的路径
TOKENIZER_PATH="pathto/deepseekr1_safe"
CHECKPOINT="pathto/deepseekr1_safe"

# 请根据实际情况以及需求修改以下参数

TP=1
PP=8
EP=8
CP=1
CP_TYPE='ulysses_cp_algo'
NUM_LAYERS=61
SEQ_LEN=4096

DISTRIBUTED_ARGS="
    --nproc_per_node $NPUS_PER_NODE \
    --nnodes $NNODES \
    --node_rank $NODE_RANK \
    --master_addr $MASTER_ADDR \
    --master_port $MASTER_PORT
"

MLA_ARGS="
    --multi-head-latent-attention \
    --qk-rope-head-dim 64 \
    --qk-nope-head-dim 128 \
    --q-lora-rank 1536 \
    --kv-lora-rank 512 \
    --v-head-dim 128 \
    --qk-layernorm
"

MOE_ARGS="
    --moe-permutation-async-comm \
    --use-fused-moe-token-permute-and-unpermute \
    --moe-token-dispatcher-type alltoall \
    --first-k-dense-replace 3 \
    --moe-layer-freq 1 \
    --n-shared-experts 1 \
    --num-experts 256 \
    --moe-router-topk 8 \
    --moe-intermediate-size 2048 \
    --moe-router-load-balancing-type noaux_tc \
    --n-group 8 \
    --topk-group 4 \
    --routed-scaling-factor 2.5 \
    --moe-aux-loss-coeff 0.0001 \
    --seq-aux \
    --norm-topk-prob \
    --moe-router-score-function sigmoid \
    --moe-router-enable-expert-bias \
    --router-gating-in-fp32 \
"

ROPE_ARGS="
    --rope-scaling-beta-fast 32 \
    --rope-scaling-beta-slow 1 \
    --rope-scaling-factor 40 \
    --rope-scaling-mscale 1.0 \
    --rope-scaling-mscale-all-dim 1.0 \
    --rope-scaling-original-max-position-embeddings 4096 \
    --rope-scaling-type yarn
"

GPT_ARGS="
    --spec mindspeed_llm.tasks.models.spec.deepseek_spec layer_spec \
    --reuse-fp32-param \
    --shape-order BNSD \
    --use-fused-rotary-pos-emb \
    --use-fused-swiglu \
    --use-fused-rmsnorm \
    --use-flash-attn \
    --use-mcore-models \
    --use-flash-attn \
    --tensor-model-parallel-size ${TP} \
    --pipeline-model-parallel-size ${PP} \
    --expert-model-parallel-size ${EP} \
    --context-parallel-size ${CP} \
    --context-parallel-algo  ${CP_TYPE} \
    --num-layers ${NUM_LAYERS} \
    --num-layer-list 7,7,7,8,8,8,8,8 \
    --hidden-size 7168 \
    --ffn-hidden-size 18432 \
    --num-attention-heads 128 \
    --tokenizer-type PretrainedFromHF  \
    --tokenizer-name-or-path ${TOKENIZER_PATH} \
    --seq-length ${SEQ_LEN} \
    --max-position-embeddings 163840 \
    --micro-batch-size 1 \
    --make-vocab-size-divisible-by 1 \
    --untie-embeddings-and-output-weights \
    --disable-bias-linear \
    --attention-dropout 0.0 \
    --init-method-std 0.02 \
    --hidden-dropout 0.0 \
    --position-embedding-type rope \
    --normalization RMSNorm \
    --use-rotary-position-embeddings \
    --swiglu \
    --prompt-type deepseek3 \
    --no-masked-softmax-fusion \
    --attention-softmax-in-fp32 \
    --vocab-size 129280 \
    --padded-vocab-size 129280 \
    --rotary-base 10000 \
    --no-gradient-accumulation-fusion \
    --norm-epsilon 1e-6 \
    --max-new-tokens 128 \ 
    --bf16
"

# 请根据实际情况修改135行中的路径
torchrun $DISTRIBUTED_ARGS ../Code/MindSpeed-LLM/inference.py \
    $GPT_ARGS \
    $MLA_ARGS \
    $ROPE_ARGS \
    $MOE_ARGS \
    --load ${CHECKPOINT} \
    --distributed-backend nccl \
    --task chat \
    | tee logs/generate_deepseekr1safe.log
