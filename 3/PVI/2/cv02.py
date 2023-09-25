import numpy as np
import cv2
import matplotlib.pyplot as plt

# uvazuji pouze, ze obrazek lze rozsekat na ctverce a iterovat pres ne

if __name__ == "__main__":
    # font
    font = cv2.FONT_HERSHEY_SIMPLEX
    # fontScale
    font_scale = 1
    # color
    color_text = (0, 0, 0)
    # offset
    text_offset_x = -80
    # text thickness
    text_thickness = 2

    color_ranges_dic = {
        "red": {"min": np.array([0, 0, 0], np.uint8), "max": np.array([5, 50, 50], np.uint8)},
        "green": {"min": np.array([40, 255, 255], np.uint8), "max": np.array([60, 255, 255], np.uint8)},
        "blue": {"min": np.array([100, 255, 255], np.uint8), "max": np.array([120, 255, 255], np.uint8)},
        "yellow": {"min": np.array([20, 255, 255], np.uint8), "max": np.array([30, 255, 255], np.uint8)},
        "orange": {"min": np.array([5, 255, 255], np.uint8), "max": np.array([15, 255, 255], np.uint8)},
        "violet": {"min": np.array([130, 255, 255], np.uint8), "max": np.array([150, 255, 255], np.uint8)},
        "pink": {"min": np.array([150, 255, 255], np.uint8), "max": np.array([170, 255, 255], np.uint8)}
    }

    bgr = cv2.imread("cv02_01.bmp")
    hsv = cv2.cvtColor(bgr, cv2.COLOR_BGR2HSV)
    gray = cv2.cvtColor(bgr, cv2.COLOR_BGR2GRAY)

    image = bgr.copy()

    y, x, _ = np.shape(bgr)

    for yy in range(100, y, 200):
        for xx in range(100, x, 200):
            # org
            text_origin = (xx + text_offset_x, yy)

            if gray[yy, xx] == 255:
                image = cv2.putText(image, "white", text_origin, font,
                                    font_scale, color_text, 1, cv2.LINE_AA)
                continue
            if gray[yy, xx] == 0:
                image = cv2.putText(image, "black", text_origin, font,
                                    font_scale, (255, 255, 255), text_thickness, cv2.LINE_AA)
                continue

            for key in color_ranges_dic.keys():
                range_min = color_ranges_dic[key]["min"]
                range_max = color_ranges_dic[key]["max"]
                pixel_threshed = cv2.inRange(hsv[yy, xx], range_min, range_max)
                if pixel_threshed[0] == 255:
                    image = cv2.putText(image, key, text_origin, font,
                                        font_scale, color_text, 1, cv2.LINE_AA)
                    break
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    plt.imshow(image)
    plt.show()
