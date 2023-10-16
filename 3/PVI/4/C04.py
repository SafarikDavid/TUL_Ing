import numpy as np
import matplotlib.pyplot as plt
import cv2
import os
from scipy.fft import dctn


def create_image_list(folder_path):
    # Empty image list
    image_list = []
    for filename in os.listdir(folder_path):
        if filename.endswith(('.jpg', '.png', '.jpeg', '.bmp')):  # Check for image file extensions
            # Construct the full file path
            file_path = os.path.join(folder_path, filename)
            # Read the image using OpenCV
            image = cv2.imread(file_path)
            if image is not None:
                # Append the image to the list
                image_list.append(image)
    return image_list


def calculate_amplitude_spectrum(image):
    dft = np.fft.fft2(image)
    # Posunout nulovou frekvenci do středu
    dft_shifted = np.fft.fftshift(dft)
    # Amplitudové spektrum (logaritmus z absolutní hodnoty)
    amplitude_spectrum = np.log(np.abs(dft_shifted) + 1)  # Přidáme 1, aby se vyhnuli log(0)
    return amplitude_spectrum


def plot_im_hi_sp(image1, title1, image2, title2, super_title=None):
    spectrum1 = calculate_amplitude_spectrum(image1)
    hist1 = cv2.calcHist([image1], [0], None, [256], [0, 256])
    plt.subplot(2, 3, 1)
    plt.imshow(image1, cmap='gray')
    plt.title(title1)
    plt.subplot(2, 3, 2)
    plt.plot(hist1)
    plt.title("Histogram")
    plt.subplot(2, 3, 3)
    plt.imshow(spectrum1, cmap='jet')
    plt.colorbar()
    plt.title("Spectrum")

    spectrum2 = calculate_amplitude_spectrum(image2)
    hist2 = cv2.calcHist([image2], [0], None, [256], [0, 256])
    plt.subplot(2, 3, 4)
    plt.imshow(image2, cmap='gray')
    plt.title(title2)
    plt.subplot(2, 3, 5)
    plt.plot(hist2)
    plt.title("Histogram")
    plt.subplot(2, 3, 6)
    plt.imshow(spectrum2, cmap='jet')
    plt.colorbar()
    plt.title("Spectrum")

    if super_title is not None:
        plt.suptitle(super_title)
    plt.show()


def my_median(image):
    output = image.copy()
    im_shape = image.shape
    for x in range(2, im_shape[0] - 2):
        for y in range(2, im_shape[1] - 2):
            output[x, y] = np.median(image[x-2:x+2, y-2:y+2])
    return output


def main():
    bgr = cv2.imread('pvi_cv04.png')
    rgb = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
    gray = cv2.cvtColor(bgr, cv2.COLOR_BGR2GRAY)

    medIm = cv2.medianBlur(gray, 5)
    plot_im_hi_sp(gray, 'gray', medIm, "cv2 median")

    averIm = cv2.blur(gray, (3, 3))
    plot_im_hi_sp(gray, 'gray', averIm, "cv2 average")

    myMedIm = my_median(gray)
    plot_im_hi_sp(gray, 'gray', myMedIm, "my median")

    plot_im_hi_sp(medIm, 'cv2 median', myMedIm, 'my median')

    list_image = create_image_list("images")
    list_gray = []
    for idx, image in enumerate(list_image):
        gray_temp = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        list_gray.append(gray_temp)
        imC = cv2.Canny(gray_temp, 100, 256)
        plt.subplot(2, 6, idx+1)
        plt.imshow(gray_temp, cmap='jet')
        plt.colorbar()
        plt.subplot(2, 6, idx + 7)
        plt.imshow(imC, cmap='jet')
        plt.colorbar()
    plt.show()


if __name__ == "__main__":
    main()
