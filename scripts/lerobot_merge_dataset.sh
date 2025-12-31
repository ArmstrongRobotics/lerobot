# lerobot-edit-dataset  \
#     --repo_id ${HF_USER}/pnp_cup_merged_basic123_random_start \
#     --operation.type merge \
#     --operation.repo_ids "['${HF_USER}/pick_and_place_single_cup_in_tub_basic', '${HF_USER}/pick_and_place_single_cup_in_tub_basic2', '${HF_USER}/pnp_cup_basic3', '${HF_USER}/pnp_cup_random_start']"

lerobot-edit-dataset  \
    --repo_id ${HF_USER}/pnp_9in_plates_recover_random_merged \
    --operation.type merge \
    --operation.repo_ids "['${HF_USER}/pnp_9in_plates_corner', '${HF_USER}/pnp_9in_plates_corner_recover', '${HF_USER}/pnp_9in_plates_corner_recover_finger_sep', '${HF_USER}/pnp_9in_plates_corner_random_start']"