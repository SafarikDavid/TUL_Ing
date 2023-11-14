import numpy as np
import matplotlib.pyplot as plt
import cv2
from scipy.ndimage import label
from scipy.ndimage import rotate
import easyocr


def main():
    spz_image = cv2.imread('pvi_cv08/pvi_cv08_spz.png')
    spz_image_rgb = cv2.cvtColor(spz_image, cv2.COLOR_BGR2RGB)
    spz_image_gray = cv2.cvtColor(spz_image, cv2.COLOR_BGR2GRAY)
    spz_image_segmented = cv2.threshold(spz_image_gray, 250, 255, cv2.THRESH_BINARY)[1]

    kernel = np.ones((5, 5))
    spz_image_no_text = spz_image_segmented.copy()
    spz_image_no_text = cv2.morphologyEx(spz_image_no_text, cv2.MORPH_OPEN, kernel, iterations=1)
    spz_image_no_text = cv2.morphologyEx(spz_image_no_text, cv2.MORPH_CLOSE, kernel, iterations=5)
    spz_image_no_text = np.invert(spz_image_no_text)
    spz_image_no_text[spz_image_no_text < 255] = 0

    dst = cv2.cornerHarris(spz_image_no_text, 5, 7, 0.04)
    dst = cv2.dilate(dst, None)
    img = spz_image_rgb.copy()
    img[dst > 0.01 * dst.max()] = [255, 0, 0]

    plt.subplot(2, 2, 1)
    plt.imshow(spz_image_rgb)
    plt.title('Orig. Im.')

    plt.subplot(2, 2, 2)
    plt.imshow(spz_image_segmented, cmap='jet')
    plt.title('Bin. Im.')
    plt.colorbar()

    plt.subplot(2, 2, 3)
    plt.imshow(spz_image_no_text, cmap='jet')
    plt.title('Bin. Im. - Result')
    plt.colorbar()

    plt.subplot(2, 2, 4)
    plt.imshow(img)
    plt.title('Im. + Harris')

    plt.show()

    # finding center coordinates
    dst[dst <= 0.01 * dst.max()] = 0.
    dst[dst > 0] = 1.
    labels_dst, ncc = label(dst)
    nonzero_labels_coords = np.nonzero(dst)
    nonzero_labels = labels_dst[nonzero_labels_coords]
    centers = []
    for i in range(1, ncc + 1):
        yy = nonzero_labels_coords[0][nonzero_labels == i]
        xx = nonzero_labels_coords[1][nonzero_labels == i]
        yy_center = np.mean(yy, dtype=np.int32)
        xx_center = np.mean(xx, dtype=np.int32)
        centers.append([xx_center, yy_center])
    centers = np.array(centers)

    rotation_radians = np.arctan((centers[0, 1] - centers[2, 1]) / (centers[0, 0] - centers[2, 0]))
    rotation_degrees = np.rad2deg(rotation_radians)

    spz_image_rgb_rotated = rotate(spz_image_rgb, rotation_degrees)

    reader = easyocr.Reader(['cs'], gpu=False)
    text = reader.readtext(spz_image_rgb_rotated)
    full_text = ''
    for i in range(len(text)):
        full_text += text[i][1] + ' '
    full_text = full_text[0:-1]

    cv2.putText(spz_image_rgb_rotated, full_text, [20, 100], cv2.FONT_HERSHEY_SIMPLEX, 2, (0, 255, 0), 2)

    plt.imshow(spz_image_rgb_rotated)
    plt.show()


if __name__ == "__main__":
    main()
