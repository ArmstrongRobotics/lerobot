lerobot-teleoperate \
    --robot.type=lerobot_robot_i2rt_bimanual \
    --teleop.type=lerobot_teleoperator_i2rt_bimanual \
    --teleop.id=leader \
    --display_data=true \
    --teleop.left.can_channel=can_leader_l \
    --teleop.right.can_channel=can_leader_r \
    --robot.left.can_channel=can_follower_l \
    --robot.right.can_channel=can_follower_r \
    --robot.left.cameras="{ wrist: {type: opencv, index_or_path: /dev/video-wrist, width: 640, height: 480, fps: 30}, scene_cam1: {type: opencv, index_or_path: /dev/video-scene1, width: 640, height: 480, fps: 30}}" \
    --robot.left.follower_gripper_min=0.0 \
    --robot.left.follower_gripper_max=0.8 \
    --robot.right.follower_gripper_min=0.0 \
    --robot.right.follower_gripper_max=0.8 \
    
## Single leader, bimanual follower:
# lerobot-teleoperate \
#     --robot.type=lerobot_robot_i2rt_bimanual \
#     --teleop.type=lerobot_teleoperator_i2rt \
#     --teleop.id=leader \
#     --display_data=true \
#     --teleop.can_channel=can_leader_l \
#     --robot.left.can_channel=can_follower_l \
#     --robot.right.can_channel=can_follower_r \
#     --robot.left.cameras="{ wrist: {type: opencv, index_or_path: /dev/video-wrist, width: 640, height: 480, fps: 30}, scene_cam1: {type: opencv, index_or_path: /dev/video-scene1, width: 640, height: 480, fps: 30}}" \
#     --robot.left.follower_gripper_min=0.0 \
#     --robot.left.follower_gripper_max=0.8 \
#     --robot.right.follower_gripper_min=0.0 \
#     --robot.right.follower_gripper_max=0.8 \
    
    