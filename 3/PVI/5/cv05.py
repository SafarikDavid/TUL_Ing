import numpy as np
import matplotlib.pyplot as plt
import cv2
from scipy.ndimage import label


def main():
    bgr = cv2.imread('pvi_cv05_mince_noise.png')
    rgb = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
    gray = cv2.cvtColor(bgr, cv2.COLOR_BGR2GRAY)
    hsv = cv2.cvtColor(bgr, cv2.COLOR_BGR2HSV)
    hue = hsv[:, :, 0]
    hist_gray = cv2.calcHist([gray], [0], None, [256], [0, 256])
    hist_hue = cv2.calcHist([hue], [0], None, [256], [0, 256])

    binary_gray = np.zeros_like(gray)
    binary_gray[gray > 130] = 1

    binary_hue = np.zeros_like(hue)
    binary_hue[hue < 50] = 1

    plt.subplot(2, 3, 1)
    plt.imshow(gray, cmap='gray')
    plt.title("Gray Image")
    plt.colorbar()

    plt.subplot(2, 3, 2)
    plt.plot(hist_gray)
    plt.title('Gray Image Histogram')

    plt.subplot(2, 3, 3)
    plt.imshow(binary_gray, cmap='jet')
    plt.title("Binary Image from Gray")
    plt.colorbar()

    plt.subplot(2, 3, 4)
    plt.imshow(hue, cmap='jet')
    plt.title("Hue Image")
    plt.colorbar()

    plt.subplot(2, 3, 5)
    plt.plot(hist_hue)
    plt.title('Hue Image Histogram')

    plt.subplot(2, 3, 6)
    plt.imshow(binary_hue, cmap='jet')
    plt.title("Binary Image from Hue")
    plt.colorbar()

    plt.show(block=False)

    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 5))
    opening_hue = cv2.morphologyEx(binary_hue, cv2.MORPH_OPEN, kernel)

    plt.figure()

    plt.subplot(1, 2, 1)
    plt.imshow(binary_hue, cmap='jet')
    plt.colorbar()
    plt.title("Binary Image from Hue")

    plt.subplot(1, 2, 2)
    plt.imshow(opening_hue, cmap='jet')
    plt.colorbar()
    plt.title("Binary Image from Hue - Opening")

    plt.show(block=False)

    labels_hue, ncc = label(opening_hue)

    plt.figure()

    plt.subplot(1, 2, 1)
    plt.imshow(opening_hue, cmap='jet')
    plt.colorbar()
    plt.title("Binary Image from Hue - Opening")

    plt.subplot(1, 2, 2)
    plt.imshow(labels_hue, cmap='jet')
    plt.colorbar()
    plt.title("Binary Image from Hue - Label")

    plt.show(block=False)

    classification_vals = [4000, 4500, 5300, 6500]
    classification_dic = {
        4000: '1 Kc',
        4500: '2 Kc',
        5300: '5 Kc',
        6500: '10 Kc'
    }

    rgb_mass = rgb.copy()
    rgb_classification = rgb.copy()

    mass_dic = {}
    center_of_mass_dic = {}
    for i in range(1, ncc + 1):
        indices = np.where(labels_hue == [i])
        mass = len(indices[0])
        center_of_mass = (int(np.mean(indices[1])), int(np.mean(indices[0])))
        mass_dic[i] = mass
        center_of_mass_dic[i] = center_of_mass
        cv2.putText(rgb_mass, str(mass), center_of_mass, cv2.FONT_HERSHEY_SIMPLEX, 1.0, [0, 0, 255])

        for val in classification_vals:
            if mass < val:
                cv2.putText(rgb_classification, classification_dic[val], center_of_mass, cv2.FONT_HERSHEY_SIMPLEX, 1.0, [0, 0, 255])
                break

    plt.figure()
    plt.imshow(rgb_mass)
    plt.show(block=False)

    plt.figure()
    plt.imshow(rgb_classification)
    plt.show(block=False)

    plt.show()


if __name__ == "__main__":
    main()
