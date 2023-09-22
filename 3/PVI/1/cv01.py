import numpy as np
import cv2
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
import easyocr

if __name__ == "__main__":
    # read image and convert colors
    img = cv2.imread("cv01_auto.jpg")
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    yuv = cv2.cvtColor(img, cv2.COLOR_BGR2YUV)
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    # segmentation of car
    seg = yuv[:, :, 1]
    _, seg = cv2.threshold(seg, 150, 255, cv2.THRESH_BINARY)
    kernel = np.ones((5, 5), np.uint8)
    seg = cv2.dilate(seg, kernel, iterations=10)

    contours, hierarchy = cv2.findContours(seg, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    # cv2.drawContours(img, contours, -1, (0, 255, 0), 3)

    # segment car in image
    only_car = rgb.copy()
    only_car[seg <= 0] = 0
    # cv2.imshow("ss", only_car)
    # cv2.waitKey()

    pixels = only_car.reshape(-1, 3)
    pixels = pixels[np.any(pixels != [0, 0, 0], axis=-1)]
    kmeans = KMeans(n_clusters=1)
    kmeans.fit(pixels)

    counts = np.bincount(kmeans.labels_)
    dominant_color = kmeans.cluster_centers_[np.argmax(counts)]
    dominant_color = dominant_color.round(0).astype(int)

    print("dominant color:", dominant_color)

    # bounding rectangle
    x, y, w, h = cv2.boundingRect(contours[0])
    img = cv2.rectangle(img, (x, y), (x + w, y + h), (0, 255, 0), 2)

    # spz
    # https://www.youtube.com/watch?v=n-8oCPjpEvM
    reader = easyocr.Reader(['cs'], gpu=False)
    text = reader.readtext(gray[x:x+w, y:y+h])

    for t in text:
        print(t[1])

    # show car
    cv2.imshow("center of car", img)
    cv2.waitKey()
