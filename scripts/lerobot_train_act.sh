policy_type=act
dataset=pnp_cup_merged_basic123_random_start
job_name=${policy_type}_${dataset}_8x_test
lerobot-train \
  --dataset.repo_id=${HF_USER}/${dataset} \
  --policy.type=${policy_type} \
  --output_dir=outputs/train/${job_name} \
  --job_name=${job_name} \
  --policy.device=cuda \
  --wandb.enable=true \
  --policy.repo_id=${HF_USER}/my_policy \
  --steps=800000

hf upload ${HF_USER}/${job_name} \
  outputs/train/${job_name}/checkpoints/last/pretrained_model
