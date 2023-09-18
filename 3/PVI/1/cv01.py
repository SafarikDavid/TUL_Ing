import numpy as np
import cv2
import matplotlib.pyplot as plt

if __name__ == "__main__":
    img = cv2.imread("cv01_auto.jpg")
    img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    car_cascade = cv2.CascadeClassifier('haarcascade_cars.xml')

    cars = car_cascade.detectMultiScale(img_gray, 1.1, 3)

    for (x, y, w, h) in cars:
        print(x)
        cv2.rectangle(img, (x, y), (x + w, y + h), (0, 255, 0), 2)

    cv2.imshow('car', img)
    cv2.waitKey()