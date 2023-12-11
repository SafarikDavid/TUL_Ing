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
    res_arr = []
    res_class_arr = []
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
        A_ori = np.abs(np.fft.ifft2(M))
        A = np.zeros_like(A_ori)
        A[0:32, 0:32] = A_ori[32:64, 32:64]
        A[32:64, 32:64] = A_ori[0:32, 0:32]
        A[0:32, 32:64] = A_ori[32:64, 0:32]
        A[32:64, 0:32] = A_ori[0:32, 32:64]
        O = A[22:42, 22:42].copy()
        O[5:15, 5:15] = 0
        O = O.flatten()
        O = np.delete(O, np.where(O == 0))
        V = A[27:37, 27:37].copy()
        V = V.flatten()

        res_i = (np.max(V) - np.mean(O))/np.std(O)
        # plt.imshow(A, cmap='jet')
        # plt.colorbar()
        # plt.show()
        res_arr.append(res_i)
        res_class_arr.append(reff_dic_key)
    max_res_idx = np.argmax(res_arr)
    print(f"best class is {res_class_arr[max_res_idx]}")


if __name__ == "__main__":
    main()
