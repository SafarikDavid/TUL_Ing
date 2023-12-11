import glob

import cv2
import numpy as np
from matplotlib import pyplot as plt
from scipy import fft
from scipy import ndimage


def main():
    unknown_bgr = cv2.imread('data/unknown.bmp')
    unknown_rgb = cv2.cvtColor(unknown_bgr, cv2.COLOR_BGR2RGB)
    unknown_gray = cv2.cvtColor(unknown_bgr, cv2.COLOR_BGR2GRAY)
    vec_unknown = np.fft.fft2(unknown_gray).flatten().reshape(4096, 1)
    fft_dic = {}
    X = []
    for im_path in glob.glob('data/p*.bmp'):
        bgr = cv2.imread(im_path)
        rgb = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
        gray = cv2.cvtColor(bgr, cv2.COLOR_BGR2GRAY)
        class_id = im_path[-6]
        if class_id not in fft_dic.keys():
            fft_dic[class_id] = []
        fft_dic[class_id].append(np.fft.fft2(gray).flatten())

    H = []
    for reff_dic_key in fft_dic.keys():
        X = fft_dic[reff_dic_key]
        X = np.array(X).transpose()
        Xp = X.conjugate().transpose()
        u = np.ones([X.shape[1], 1])
        D = np.zeros([X.shape[0], X.shape[0]], dtype=complex)
        for j in range(D.shape[0]):
            temp = np.sum(np.power(X[j, :], 2))/X.shape[1] #abs asi ne?
            D[j, j] = temp
        Dm1 = np.linalg.inv(D)
        M0 = np.matmul(Dm1, X)
        H_temp = np.matmul(np.matmul(M0, np.matmul(Xp, M0)), u)
        H.append(H_temp)

        R = vec_unknown * H_temp
        M = R.reshape(64, 64)
        A = np.abs(np.fft.ifft2(M))
        A = np.flip(A, axis=0)
        A = np.flip(A, axis=1)
        O = A[22:42, 22:42]
        V = A[27:37, 27:37]

    print()


if __name__ == "__main__":
    main()
