#!/bin/bash

sudo ip link set up can_leader_l type can bitrate 1000000
sudo ip link set up can_follower_l type can bitrate 1000000
