lerobot-replay \
    --robot.type=lerobot_robot_i2rt \
    --robot.id=follower \
    --robot.can_channel=can_follower_l \
    --dataset.repo_id=${HF_USER}/pick_and_place_cups \
    --dataset.episode=0 # choose the episode you want to replay