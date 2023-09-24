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
    rgb_only_car = rgb.copy()
    rgb_only_car[seg <= 0] = 0

    pixels = rgb_only_car.reshape(-1, 3)
    pixels = pixels[np.any(pixels != [0, 0, 0], axis=-1)]
    kmeans = KMeans(n_clusters=2)
    kmeans.fit(pixels)

    counts = np.bincount(kmeans.labels_)
    dominant_color = kmeans.cluster_centers_[np.argmax(counts)]
    dominant_color = dominant_color.round(0).astype(int)

    print("dominant color:", dominant_color)

    # bounding rectangle
    x, y, w, h = cv2.boundingRect(contours[0])
    img = cv2.rectangle(img, (x, y), (x + w, y + h), (int(dominant_color[2]), int(dominant_color[1]), int(dominant_color[0])), 3)

    # spz
    # https://www.youtube.com/watch?v=n-8oCPjpEvM
    gray_only_car = gray.copy()
    gray_only_car[seg <= 0] = 0
    gray_only_car = gray_only_car[y:y + h, x:x + w]

    reader = easyocr.Reader(['cs'], gpu=False)
    text = reader.readtext(gray_only_car)

    for t in text:
        bbox, text, score = t
        # text_again = reader.readtext(gray_only_car[int(bbox[0][1]):int(bbox[2][1]), int(bbox[0][0]):int(bbox[2][0])])
        text_origin = [int(x) for x in bbox[0]]
        text_origin = [text_origin[0] + x, text_origin[1] + y]
        cv2.putText(img, text, text_origin, cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)
        print(text)

    # show car
    cv2.imshow("car", img)
    cv2.waitKey()
