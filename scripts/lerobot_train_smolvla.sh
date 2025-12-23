policy_type=smolVLA
dataset=pnp_cup_merged_basic123_random_start
# dataset=pnp_9in_plates_corner
job_name=${policy_type}_${dataset}
lerobot-train \
  --dataset.repo_id=${HF_USER}/${dataset} \
  --output_dir=outputs/train/${job_name} \
  --job_name=${job_name} \
  --policy.device=cuda \
  --wandb.enable=false \
  --policy.repo_id=${HF_USER}/my_policy \
  --policy.path=lerobot/smolvla_base \
  --batch_size=64 \
  --save_freq=5000 \
  --steps=200000 \
  --rename_map='{"observation.images.scene.top_down": "observation.images.camera1", "observation.images.wrist.top": "observation.images.camera2"}'

hf upload ${HF_USER}/${job_name} \
  outputs/train/${job_name}/checkpoints/last/pretrained_model
