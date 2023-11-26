import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt
from skimage import transform
import easyocr


def main():
    reader = easyocr.Reader(['cs'])

    MIN_MATCH_COUNT = 10
    img1 = cv.imread('data/obcansky_prukaz_cr_sablona_2012_2014.png')  # queryImage
    img1 = cv.cvtColor(img1, cv.COLOR_BGR2GRAY)
    img2 = cv.imread('data/TS10_01.jpg')  # trainImage
    img2 = cv.cvtColor(img2, cv.COLOR_BGR2GRAY)
    img2_copy = img2.copy()

    # Initiate SIFT detector
    sift = cv.SIFT_create()

    # find the keypoints and descriptors with SIFT
    kp1, des1 = sift.detectAndCompute(img1, None)
    kp2, des2 = sift.detectAndCompute(img2, None)

    FLANN_INDEX_KDTREE = 1
    index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
    search_params = dict(checks=50)

    flann = cv.FlannBasedMatcher(index_params, search_params)

    matches = flann.knnMatch(des1, des2, k=2)

    # store all the good matches as per Lowe's ratio test.
    good = []
    for m, n in matches:
        if m.distance < 0.7 * n.distance:
            good.append(m)

    if len(good) > MIN_MATCH_COUNT:
        src_pts = np.float32([kp1[m.queryIdx].pt for m in good]).reshape(-1, 1, 2)
        dst_pts = np.float32([kp2[m.trainIdx].pt for m in good]).reshape(-1, 1, 2)

        M, mask = cv.findHomography(src_pts, dst_pts, cv.RANSAC, 5.0)
        matchesMask = mask.ravel().tolist()

        h, w = img1.shape
        pts = np.float32([[0, 0], [0, h - 1], [w - 1, h - 1], [w - 1, 0]]).reshape(-1, 1, 2)
        dst = cv.perspectiveTransform(pts, M)

        img2 = cv.polylines(img2, [np.int32(dst)], True, 255, 3, cv.LINE_AA)
    else:
        print("Not enough matches are found - {}/{}".format(len(good), MIN_MATCH_COUNT))
        matchesMask = None
        return

    draw_params = dict(matchColor=(0, 255, 0),  # draw matches in green color
                       singlePointColor=None,
                       matchesMask=matchesMask,  # draw only inliers
                       flags=2)

    img3 = cv.drawMatches(img1, kp1, img2, kp2, good, None, **draw_params)

    plt.imshow(img3, 'gray')
    plt.show()

    dst = np.array([np.int32(dst)[0][0], np.int32(dst)[1][0], np.int32(dst)[2][0], np.int32(dst)[3][0]])
    src = np.array([[0, 0], [0, 420], [669, 420], [669, 0]])
    tform3 = transform.ProjectiveTransform()
    tform3.estimate(src, np.int32(dst))
    warped = transform.warp(img2_copy, tform3, output_shape=(420, 669))

    plt.imshow(warped, 'gray')
    plt.show()

    kernel = np.array([[0, -1, 0], [-1, 5, -1], [0, -1, 0]])

    surname_cutout = warped[78:110, 150:327].astype(np.float32)
    first_name_cutout = warped[105:135, 150:327].astype(np.float32)
    face_cutout = warped[136:402, 17:233].astype(np.float32)

    surname_text = reader.readtext(surname_cutout)
    first_name_text = reader.readtext(first_name_cutout)
    print()

    plt.subplot(3, 1, 1)
    plt.imshow(surname_cutout, 'gray')
    plt.subplot(3, 1, 2)
    plt.imshow(first_name_cutout, 'gray')
    plt.subplot(3, 1, 3)
    plt.imshow(face_cutout, 'gray')

    plt.show()


if __name__ == "__main__":
    main()
