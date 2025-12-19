from lerobot.cameras.opencv.configuration_opencv import OpenCVCameraConfig
from lerobot.cameras.opencv.camera_opencv import OpenCVCamera
from lerobot.cameras.configs import ColorMode, Cv2Rotation
import os
import cv2

# Construct an `OpenCVCameraConfig` with your desired FPS, resolution, color mode, and rotation.
config = OpenCVCameraConfig(
    index_or_path="/dev/video-wrist",
    fps=15,
    width=640,
    height=480,
    color_mode=ColorMode.BGR,
    rotation=Cv2Rotation.NO_ROTATION
)

# Instantiate and connect an `OpenCVCamera`, performing a warm-up read (default).
camera = OpenCVCamera(config)
camera.connect()

# Read frames asynchronously in a loop via `async_read(timeout_ms)`
out_folder = "/tmp/test_cameras_dump"
if os.path.exists(out_folder):
    os.system(f"rm -rf {out_folder}")
os.makedirs(out_folder)
try:
    while True:
    # for i in range(10):
        frame = camera.read()
        # cv2.imwrite(f"{out_folder}/frame_{i}.png", frame)
        # imshow in loop
        cv2.imshow("Async Frame", frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        # print(f"Async frame {i} shape:", frame.shape)
finally:
    camera.disconnect()