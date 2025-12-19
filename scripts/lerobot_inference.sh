policy=act_pnp_cup_merged_basic123_random_start_delta_joints_8x
checkpoint=440000  # or last
episode_time_s=10000
num_episodes=24
# num_episodes=1

lerobot-record \
  --robot.type=lerobot_robot_i2rt \
  --robot.id=follower \
  --teleop.type=lerobot_teleoperator_i2rt \
  --teleop.id=leader \
  --display_data=true \
  --policy.n_action_steps=25 \
  --dataset.push_to_hub=False \
  --dataset.repo_id=${HF_USER}/eval_${policy}_test \
  --dataset.num_episodes=${num_episodes} \
  --dataset.episode_time_s=${episode_time_s} \
  --dataset.single_task="Pick up cups and place in tub" \
  --policy.path=outputs/train/${policy}/checkpoints/${checkpoint}/pretrained_model \
  --robot.cameras="{ wrist.top: {type: opencv, index_or_path: /dev/video-wrist, width: 640, height: 480, fps: 30}, scene.top_down: {type: opencv, index_or_path: /dev/video-scene1, width: 640, height: 480, fps: 30}}"


#   --policy.path=${HF_USER}/${policy} \
  # --policy.temporal_ensemble_coeff="-0.05" \
  # --policy.n_action_steps=1 \
#  --policy.path=outputs/train/act_pnp_cup_merged_basic123_random_start_8x/checkpoints/440000/pretrained_model/ \
# act_pnp_cup_merged_basic123_random_start_delta_joints_8x