dataset=pnp_cup_random_start
lerobot-record \
    --robot.type=lerobot_robot_i2rt \
    --robot.id=follower \
    --teleop.type=lerobot_teleoperator_i2rt \
    --teleop.id=leader \
    --dataset.repo_id=${HF_USER}/${dataset} \
    --dataset.num_episodes=20 \
    --dataset.single_task="Pick up cups and place in tub" \
    --dataset.push_to_hub=True \
    --resume=false \
    --display_data=true \
    --dataset.episode_time_s=10000 \
    --dataset.reset_time_s=10000 \
    --robot.cameras="{ wrist.top: {type: opencv, index_or_path: /dev/video-wrist, width: 640, height: 480, fps: 30}, scene.top_down: {type: opencv, index_or_path: /dev/video-scene1, width: 640, height: 480, fps: 30}}"

# hf upload ${HF_USER}/${dataset} ~/.cache/huggingface/lerobot/${HF_USER}/${dataset} --repo-type dataset