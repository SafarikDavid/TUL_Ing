import numpy as np
import cv2
import matplotlib.pyplot as plt


def rotate(img, angle, center = None, scale = 1.0):
    (h, w) = img.shape[:2]
    if center is None:
        center = (w / 2, h / 2)
    M = cv2.getRotationMatrix2D(center, angle, scale)
    rotated = cv2.warpAffine(img, M, (w, h))
    return rotated


if __name__ == "__main__":
    # font
    font = cv2.FONT_HERSHEY_SIMPLEX
    # fontScale
    font_scale = 0.5
    # color
    color_text = (255, 255, 255)
    # offset
    text_offset_x = -25
    text_offset_y = 40
    # text thickness
    text_thickness = 1

    color_ranges_dic = {
        "red": {"min": np.array([0, 0, 0], np.uint8), "max": np.array([5, 50, 50], np.uint8)},
        "green": {"min": np.array([40, 255, 255], np.uint8), "max": np.array([60, 255, 255], np.uint8)},
        "blue": {"min": np.array([100, 255, 255], np.uint8), "max": np.array([120, 255, 255], np.uint8)},
        "yellow": {"min": np.array([20, 255, 255], np.uint8), "max": np.array([30, 255, 255], np.uint8)},
        "orange": {"min": np.array([5, 255, 255], np.uint8), "max": np.array([15, 255, 255], np.uint8)},
        "violet": {"min": np.array([130, 255, 255], np.uint8), "max": np.array([150, 255, 255], np.uint8)},
        "pink": {"min": np.array([150, 255, 255], np.uint8), "max": np.array([170, 255, 255], np.uint8)}
    }

    bgr = cv2.imread("cv02_02.bmp")
    rgb = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
    hsv = cv2.cvtColor(bgr, cv2.COLOR_BGR2HSV)
    gray = cv2.cvtColor(bgr, cv2.COLOR_BGR2GRAY)

    image = bgr.copy()

    rotation_idx = 1

    y, x, _ = np.shape(bgr)

    for yy in range(50, y, 100):
        for xx in range(50, x, 100):
            # org
            text_origin = (xx + text_offset_x, yy + text_offset_y)

            # rotation
            rotation_scale_divisor = 2 if rotation_idx % 2 == 0 else 1
            cutout = image[yy-50:yy+50, xx-50:xx+50]
            rotated_cutout = rotate(cutout, 45*rotation_idx, [50, 50], 1.0 / rotation_scale_divisor)
            rotation_idx += 1
            image[yy-50:yy+50, xx-50:xx+50] = rotated_cutout

            # color extraction
            color_to_identify = hsv[yy-50:yy+50, xx-50:xx+50]
            color_to_identify = color_to_identify[gray[yy-50:yy+50, xx-50:xx+50] != 0]
            color_to_identify = np.median(color_to_identify, axis=0)
            color_to_identify = color_to_identify.astype(np.uint8)

            # color identification
            for key in color_ranges_dic.keys():
                range_min = color_ranges_dic[key]["min"]
                range_max = color_ranges_dic[key]["max"]
                pixel_threshed = cv2.inRange(color_to_identify, range_min, range_max)
                if pixel_threshed[0] == 255:
                    image = cv2.putText(image, key, text_origin, font,
                                        font_scale, color_text, 1, cv2.LINE_AA)
                    break
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    plt.imshow(image)
    plt.show()
