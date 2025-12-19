policy_type=pi05
dataset=pnp_cup_merged_basic123_random_start
job_name=${policy_type}_${dataset}_delta_joints_8x
lerobot-train \
    --dataset.repo_id=${HF_USER}/${dataset} \
    --policy.type=${policy_type} \
    --output_dir=outputs/train/${job_name} \
    --job_name=${job_name} \
    --policy.device=cuda \
    --wandb.enable=false \
    --policy.repo_id=${HF_USER}/my_policy \
    --steps=800000 \
    --batch_size=8 \
    --policy.compile_model=true \
    --policy.gradient_checkpointing=true \
    --policy.dtype=bfloat16 \
    --policy.pretrained_path=lerobot/pi05_base

hf upload ${HF_USER}/${job_name} \
          outputs/train/${job_name}/checkpoints/last/pretrained_model