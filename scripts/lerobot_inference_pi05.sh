policy=pi05_pnp_cup_merged_basic123_random_start_delta_joints_8x
checkpoint=015000  # or last
episode_time_s=10000
num_episodes=24
repo_id=${HF_USER}/eval_${policy}_test 
# num_episodes=1

rm -rf /home/armstrong/.cache/huggingface/lerobot/${repo_id}

lerobot-record \
  --robot.type=lerobot_robot_i2rt \
  --robot.id=follower \
  --teleop.type=lerobot_teleoperator_i2rt \
  --teleop.id=leader \
  --teleop.can_channel=can_leader_l \
  --display_data=true \
  --policy.n_action_steps=50 \
  --policy.compile_model=false \
  --dataset.push_to_hub=False \
  --dataset.repo_id=${repo_id} \
  --dataset.num_episodes=${num_episodes} \
  --dataset.episode_time_s=${episode_time_s} \
  --dataset.single_task="Pick up cups and place in tub" \
  --policy.path=/home/armstrong/i2rt_repos/lerobot/outputs/train/${policy}/checkpoints/${checkpoint}/pretrained_model \
  --robot.can_channel=can_follower_l \
  --robot.cameras="{ wrist.top: {type: opencv, index_or_path: /dev/video-wrist, width: 640, height: 480, fps: 30}, scene.top_down: {type: opencv, index_or_path: /dev/video-scene1, width: 640, height: 480, fps: 30}}" 


#   --policy.path=${HF_USER}/${policy} \
  # --policy.temporal_ensemble_coeff="-0.05" \
  # --policy.n_action_steps=1 \
#  --policy.path=outputs/train/act_pnp_cup_merged_basic123_random_start_8x/checkpoints/440000/pretrained_model/ \
# act_pnp_cup_merged_basic123_random_start_delta_joints_8x