import numpy as np
import matplotlib.pyplot as plt
import cv2
from scipy.ndimage import label
from scipy.ndimage import binary_opening


def kernel_construction(n):
    return np.ones((n, n), np.uint8)


def granulometry(data, sizes=None):
    if sizes is None:
        sizes = range(3, 64)
    granulo = [cv2.morphologyEx(data, cv2.MORPH_OPEN, kernel_construction(n), iterations=1).sum() for n in sizes]
    return granulo


def main():
    bgr = cv2.imread('pvi_cv06_mince.jpg')
    rgb = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
    gray = cv2.cvtColor(bgr, cv2.COLOR_BGR2GRAY)
    hsv = cv2.cvtColor(bgr, cv2.COLOR_BGR2HSV)
    hue = hsv[:, :, 0]

    histogram = cv2.calcHist([hue], [0], None, [256], [0, 256])

    segmented_hue = np.ones_like(hue)
    segmented_hue[hue > 40] = 0.

    plt.subplot(2, 2, 1)
    plt.imshow(rgb)

    plt.subplot(2, 2, 2)
    plt.imshow(hue, cmap='jet')
    plt.colorbar()

    plt.subplot(2, 2, 3)
    plt.plot(histogram)

    plt.subplot(2, 2, 4)
    plt.imshow(segmented_hue, cmap='jet')
    plt.colorbar()

    plt.show()

    # noise removal
    kernel = np.ones((3, 3), np.uint8)
    opening = cv2.morphologyEx(segmented_hue, cv2.MORPH_OPEN, kernel, iterations=2)
    # sure background area
    sure_bg = cv2.dilate(opening, kernel, iterations=3)
    # Finding sure foreground area
    dist_transform = cv2.distanceTransform(opening, cv2.DIST_L2, 5)
    ret, sure_fg = cv2.threshold(dist_transform, 0.7 * dist_transform.max(), 255, 0)
    # Finding unknown region
    sure_fg = np.uint8(sure_fg)
    unknown = cv2.subtract(sure_bg, sure_fg)

    # Marker labelling
    ret, markers = cv2.connectedComponents(sure_fg)
    # Add one to all labels so that sure background is not 0, but 1
    markers = markers + 1
    # Now, mark the region of unknown with zero
    markers[unknown >= 1.] = 0

    plt.subplot(2, 3, 1)
    plt.imshow(dist_transform, cmap='jet')
    plt.colorbar()
    plt.title('dist_transform')

    plt.subplot(2, 3, 2)
    plt.imshow(sure_fg, cmap='jet')
    plt.colorbar()
    plt.title('sure_fg')

    plt.subplot(2, 3, 3)
    plt.imshow(unknown, cmap='jet')
    plt.colorbar()
    plt.title('unknown')

    plt.subplot(2, 3, 4)
    plt.imshow(markers, cmap='jet')
    plt.colorbar()
    plt.title('markers')

    # watershed
    img = rgb.copy()
    markers = cv2.watershed(img, markers)
    watershed_border = np.zeros_like(markers, dtype=np.uint8)
    watershed_border[markers == -1.] = 1.
    watershed_border = cv2.dilate(watershed_border, kernel, iterations=1)

    plt.subplot(2, 3, 5)
    plt.imshow(watershed_border, cmap='jet')
    plt.colorbar()
    plt.title('Watershed Border')

    segmented_hue[watershed_border >= 1.] = 0.

    plt.subplot(2, 3, 6)
    plt.imshow(segmented_hue, cmap='jet')
    plt.colorbar()
    plt.title('Binary Image with Watershed')

    plt.show()

    labels, ncc = label(segmented_hue)
    for i in range(1, ncc + 1):
        if len(labels[labels == i]) < 1000:
            labels[labels == i] = 0

    plt.subplot(1, 3, 1)
    plt.imshow(segmented_hue, cmap='jet')
    plt.colorbar()
    plt.title("Binary Image with Watershed")

    plt.subplot(1, 3, 2)
    plt.imshow(labels, cmap='jet')
    plt.colorbar()
    plt.title("region ident.")

    segmented_hue[labels <= 0] = 0.

    plt.subplot(1, 3, 3)
    plt.imshow(segmented_hue, cmap='jet')
    plt.colorbar()
    plt.title("Result - Binary Image")

    plt.show()


if __name__ == "__main__":
    main()
