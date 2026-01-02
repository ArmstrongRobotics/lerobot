
import logging
import time
from dataclasses import asdict, dataclass, field
from pathlib import Path
from pprint import pformat
from typing import Any

from lerobot.datasets.lerobot_dataset import LeRobotDataset, HF_LEROBOT_HOME
# from lerobot.processor import AxisAngleToRot6d
from lerobot.datasets.video_utils import VideoEncodingManager

I2RT_YAM_XML_PATH = "/home/armstrong/i2rt_repos/i2rt/i2rt/robot_models/yam/yam.xml"
import sys
sys.path.append("/home/armstrong/i2rt_repos/")
from i2rt.i2rt.robots.kinematics import Kinematics


import tyro
import pdb
from tqdm import tqdm
import copy
import torch

CARTESIAN_ROT6D_KEYS = [
    'pose.x', 'pose.y', 'pose.z',
    'pose.rot6d_1x', 'pose.rot6d_1y', 'pose.rot6d_1z',
    'pose.rot6d_2x', 'pose.rot6d_2y', 'pose.rot6d_2z', 
    'gripper.pos'
]

def get_new_dataset(input_repo_id, output_repo_id, aa_to_rot6d, joints_to_xyzrot6d):
    assert input_repo_id != output_repo_id and output_repo_id != "", f"Invalid output repo ID"
    existing_dataset = LeRobotDataset(input_repo_id)
    new_features = copy.deepcopy(existing_dataset.features)

    if aa_to_rot6d:
        assert new_features['action']['shape'][0] == 7
        assert new_features['observation.state']['shape'][0] == 7
        new_features['action']['shape'] = (10,)
        new_features['action']['names'] = CARTESIAN_ROT6D_KEYS
        new_features['observation.state']['shape'] = (10,)
        new_features['observation.state']['names'] = CARTESIAN_ROT6D_KEYS

    elif joints_to_xyzrot6d:
        new_features['action']['shape'] = (10,)
        new_features['action']['names'] = CARTESIAN_ROT6D_KEYS
        new_features['observation.state']['shape'] = (10,)
        new_features['observation.state']['names'] = CARTESIAN_ROT6D_KEYS

    # create a new dataset with same metadata settings
    new_dataset = LeRobotDataset.create(
        output_repo_id,
        existing_dataset.fps,
        root=HF_LEROBOT_HOME / output_repo_id,
        robot_type=existing_dataset.meta.robot_type,
        features=new_features,
        use_videos=True,
        image_writer_processes=0,
        image_writer_threads=4,
        batch_encoding_size=existing_dataset.batch_encoding_size,
        tolerance_s=existing_dataset.tolerance_s
    )

    return new_dataset, len(existing_dataset.meta.episodes)

def convert(input_repo_id: str, output_repo_id: str, aa_to_rot6d: bool = False, joints_to_xyzrot6d: bool = False, is_i2rt: bool = False, push_to_hub: bool = True):
    new_dataset, num_episodes = get_new_dataset(input_repo_id, output_repo_id, aa_to_rot6d, joints_to_xyzrot6d)
    # rot6d_transform = AxisAngleToRot6d()
    kinematics = None
    if is_i2rt:
        kinematics = Kinematics(I2RT_YAM_XML_PATH, "grasp_site")

    # apply transform to each step in dataset, write result to new dataset
    with VideoEncodingManager(new_dataset):
        for eps_idx in tqdm(range(num_episodes)):
            done = False
            exception = None
            for _ in range(3):
                try:
                    existing_dataset = LeRobotDataset(input_repo_id, episodes=[eps_idx])
                    for idx in range(len(existing_dataset)):
                        frame = existing_dataset[idx]
                        if aa_to_rot6d:
                            frame['action'] = rot6d_transform._convert(frame['action'].unsqueeze(0)).squeeze().to(torch.float32)
                            frame['observation.state'] = rot6d_transform._convert(frame['observation.state'].unsqueeze(0)).squeeze().to(torch.float32)
                        elif joints_to_xyzrot6d:
                            assert kinematics is not None, "Kinematics must be provided for joints to xyzrot6d conversion"
                            joint_positions = frame['action'][:-1].numpy()
                            ee_transform = kinematics.fk(joint_positions)
                            position = ee_transform[:3, 3]
                            rot_matrix = ee_transform[:3, :3]
                            rot6d = rot_matrix[:, :2].flatten()  # Take first two columns of rotation matrix
                            new_action = torch.zeros(10, dtype=torch.float32)
                            new_action[0:3] = torch.from_numpy(position).to(torch.float32)
                            new_action[3:9] = torch.from_numpy(rot6d).to(torch.float32)
                            new_action[9] = frame['action'][-1]
                            frame['action'] = new_action

                            joint_positions_obs = frame['observation.state'][:-1].numpy()
                            ee_transform_obs = kinematics.fk(joint_positions_obs)
                            position_obs = ee_transform_obs[:3, 3]
                            rot_matrix_obs = ee_transform_obs[:3, :3]
                            rot6d_obs = rot_matrix_obs[:, :2].flatten()  # Take first two columns of rotation matrix
                            new_obs_state = torch.zeros(10, dtype=torch.float32)
                            new_obs_state[0:3] = torch.from_numpy(position_obs).to(torch.float32)
                            new_obs_state[3:9] = torch.from_numpy(rot6d_obs).to(torch.float32)
                            new_obs_state[9] = frame['observation.state'][-1]
                            frame['observation.state'] = new_obs_state
                        
                        for k in frame:
                            if "image" in k and frame[k].shape[0] == 3:
                                frame[k] = frame[k].permute((1, 2, 0))
                        
                        del frame['timestamp']
                        del frame['episode_index']
                        del frame['frame_index']
                        del frame['index']
                        del frame['task_index']

                        new_dataset.add_frame(frame)
                    new_dataset.save_episode()
                    done = True
                    break
                except Exception as e:
                    print(e)
                    exception = e
                    time.sleep(5)
            if not done:
                import pdb
                pdb.set_trace()
                raise e

    if push_to_hub:
        new_dataset.push_to_hub(tags=None, private=False)


if __name__ == "__main__":
    tyro.cli(convert)
































