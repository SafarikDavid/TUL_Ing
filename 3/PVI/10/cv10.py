import cv2
import numpy as np
from matplotlib import pyplot as plt
from scipy import fft


def bounding_box(points):
    x_coordinates, y_coordinates = zip(*points)

    return [(min(x_coordinates), min(y_coordinates)), (max(x_coordinates), max(y_coordinates))]


def main():
    threshold = 10000000
    cap = cv2.VideoCapture('pvi_cv10_video_in.mp4')
    ret, frame = cap.read()
    if ret is None or frame is None:
        print('End Of File')
        return

    background = frame.copy()
    background_gray = cv2.cvtColor(background, cv2.COLOR_BGR2GRAY)

    prev_frame = frame.copy()
    frame_number = 0
    scene_number = 0
    while True:
        ret, frame = cap.read()
        if ret is None or frame is None:
            print('End Of File')
            return

        diff = cv2.absdiff(prev_frame, frame)
        diff_sum = cv2.sumElems(diff)[0]  # Calculate the sum of absolute differences

        if diff_sum > threshold:
            print(f"Scene change detected at frame {frame_number} with diff {diff_sum}")
            scene_number += 1
        prev_frame = frame.copy()
        frame_number += 1

        if scene_number in [0, 2]:
            frame_gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            diff_background = background_gray.astype(np.int32) - frame_gray.astype(np.int32)
            # plt.imshow(diff_background, cmap='jet')
            # plt.colorbar()
            # plt.show()
            diff_background[diff_background < 30] = 0
            diff_background[diff_background >= 30] = 1
            # plt.imshow(diff_background, cmap='gray')
            # plt.show()
            points = np.where(diff_background == 1)
            if len(points[0]) <= 0: continue
            bbox = bounding_box(points)
            frame = cv2.rectangle(frame, bbox[0], bbox[1], (0, 255, 0), 1, 1)
            plt.imshow(frame)
            plt.show()

    # out = = cv2.VideoWriter(...


if __name__ == "__main__":
    main()
