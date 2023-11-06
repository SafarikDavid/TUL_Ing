import os
import numpy as np
import matplotlib.pyplot as plt
import cv2
from scipy.ndimage import label


def create_image_list(folder_path):
    # Empty image list
    image_names_list = []
    image_list = []
    image_gray_list = []
    image_segmented_list = []
    for filename in os.listdir(folder_path):
        if filename.endswith(('.jpg', '.png', '.jpeg', '.bmp')):  # Check for image file extensions
            # Construct the full file path
            file_path = os.path.join(folder_path, filename)
            # Read the image using OpenCV
            image = cv2.imread(file_path)
            if image is not None:
                image_gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
                image_segmented = image_gray.copy()
                image_segmented[image_segmented <= 0.] = 1.0
                image_segmented[image_segmented > 1.] = 0.0
                # Append the image to the list
                image_names_list.append(file_path[-5])
                image_list.append(image)
                image_gray_list.append(image_gray)
                image_segmented_list.append(image_segmented)
    return image_list, image_gray_list, image_segmented_list, image_names_list


def compare_dist(vector, class_vectors):
    distances = []
    for class_vector in class_vectors:
        distances.append(np.linalg.norm(np.array(vector)-np.array(class_vector)))
    return np.argmin(distances)


def main():
    text_image = cv2.imread('pvi_cv07_text.bmp')
    text_image_gray = cv2.cvtColor(text_image, cv2.COLOR_BGR2GRAY)
    text_image_segmented = text_image_gray.copy()
    text_image_segmented[text_image_segmented <= 0.] = 1.0
    text_image_segmented[text_image_segmented > 1.] = 0.0

    image_list, image_gray_list, image_segmented_list, image_names_list = create_image_list('dir_znaky')
    param_vectors = []
    for image_segmented in image_segmented_list:
        param_vector = []
        for x in range(image_segmented.shape[1]):
            param_vector.append(np.sum(image_segmented[:, x]))
        for y in range(image_segmented.shape[0]):
            param_vector.append(np.sum(image_segmented[y, :]))
        param_vectors.append(param_vector)

    label_kernel = np.ones((3, 3))
    labels_text_image, ncc = label(text_image_segmented, structure=label_kernel)

    recognized_text = ''
    for label_class in range(1, ncc+1):
        current_class_image = labels_text_image.copy()
        current_class_image[current_class_image != label_class] = 0.
        x, y = np.nonzero(current_class_image)
        xl, xr = x.min(), x.max()
        yl, yr = y.min(), y.max()
        cropped = current_class_image[xl:xr + 1, yl:yr + 1]
        cropped[cropped > 0.] = 1.
        param_vector = []
        for x in range(cropped.shape[1]):
            param_vector.append(np.sum(cropped[:, x]))
        for y in range(cropped.shape[0]):
            param_vector.append(np.sum(cropped[y, :]))
        detected_class = compare_dist(param_vector, param_vectors)
        recognized_text += image_names_list[detected_class]
    print(recognized_text)

    filImage = 'pvi_cv07_people.jpg'
    bgr = cv2.imread(filImage)
    gray = cv2.cvtColor(bgr, cv2.COLOR_RGB2GRAY)

    boxes = []
    with open('pvi_cv07_boxes_01.txt') as f:
        lines = f.read().splitlines()
        for line in lines:
            vec = line.split(' ')
            vec = [int(x) for x in vec]
            boxes.append(vec)

    for (x, y, w, h) in boxes:
        cv2.rectangle(bgr, (x, y), (x + w, y + h), (0, 0, 255), 2)

    faceCascade = cv2.CascadeClassifier('pvi_cv07_haarcascade_frontalface_default.xml')  # Detect faces in the image
    faces = faceCascade.detectMultiScale(
        gray,
        scaleFactor=1.4,
        minNeighbors=5,
        minSize=(30, 30),
        flags=cv2.CASCADE_SCALE_IMAGE
    )
    for (x, y, w, h) in faces:
        cv2.rectangle(bgr, (x, y), (x + w, y + h), (0, 255, 0), 2)

    IoU = 0.

    rgb = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
    plt.imshow(rgb)
    plt.show()


if __name__ == "__main__":
    main()
