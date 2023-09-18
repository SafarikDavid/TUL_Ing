# -*- coding: utf-8 -*-

# Import potrebnych modulu (knihoven):
# ------------------------------------

# Modul numpy obsahuje vsechno potrebne pro praci s poli a maticemi. Skladba
# prikazu (nazvy i parametry) velmi verne kopiruje Matlab.
import numpy as np

# Knihovna matplotlib se stara o vykreslovani grafu do oken ci souboru
# (podporuje # napr. export do pdf). Submodul pyplot pak nabizi syntaxi velmi
# podobnou jazyku Matlab.
import matplotlib.pyplot as plt

# OpenCV je velmi rozsirena C++ knihovna obsahujici nastroje pro zpracovani a
# rozpoznavani obrazu. Modul cv2 je wrapper umoznujici jeji pouziti primo
# v Pythonu.
import cv2

# Pro nacteni obrazku z disku pouzijeme knihovnu OpenCV. Obrazek bude nacten
# jako trojrozmerna matice o rozmerech (vyska, sirka, pocet kanalu). OpenCV
# nacte kanaly v poradi B, G, R, tj. bgr[:,:,0] bude modra slozka.

plt.close('all')



bgr = cv2.imread('cv01_obr.bmp')

# Vlastnost shape poli a matici numpy obsahuje jejich rozmery. bgr.shape je
# ntice (python tuple) udavajici pocet radku, pocet sloupcu, ..., v tomto
# poradi.
print('bgr.shape', bgr.shape)
print('pocet radku: {0}'.format(bgr.shape[0]))
print('pocet sloupcu: {0}'.format(bgr.shape[1]))


# Nyni prevedeme obrazek do stupnu sedi. To provedeme jako vazeny soucet
# jednotlivych kanalu. Jednotlive slozky ziskame podobne jako v Matlabu
# maticovym indexovanim. Zde bychom mohli pouzit take funkci OpenCV split:
# B, G, R = cv2.split(bgr).
B, G, R = bgr[:,:,0], bgr[:,:,1], bgr[:,:,2]
gray = 0.3*B + 0.59*G + 0.11*R

# Barevny a sedotonovy obrazek zobrazime vedle sebe. U barevneho obrazku je
# nutne obratit poradi kanalu, protoze funkce imshow() ocekava kanaly v poradi
# R, G, B, obrazek pritom mame ulozeny jako B, G, R. Funkce dstack spoji
# jednotlive slozky podel tretiho rozmeru, tzn. ze rgb bude opet 3d matice.
# dstack ocekava pouze jediny parametr typu ntice (tuple), proto je nutne
# R, G, B uzavorkovat - jinak by se intepretovalo jako 3 argumenty.
# Obdobne jako vyse, zde bychom mohli pouzit i funkci opencv merge:
# rgb = cv2.merge((R, G, B)).
plt.close('all')
rgb = np.dstack((R, G, B))
plt.figure(1)
plt.subplot(1, 2, 1)
plt.imshow(rgb)
plt.subplot(1, 2, 2)
plt.imshow(gray, cmap='gray')

# Nyni vypocteme histogram jasovych hodnot pro kazdou slozku. K tomu si
# nadefinujeme specialni funkci, ktera bude jako argument prejimat matici a
# vracet rozlozeni cetnosti jejich hodnot.
def histogram(x):
    # Nejprve inicializujeme pole cetnosti jasu na nuly.
    h = np.zeros(x.shape[0])

    # Funkce range vrati seznam hodnot od nuly do zadaneho parametru (avsak
    # BEZ nej). Dvojitym for cyklem tejdy projdeme cely obrazek a pro kazdy
    # pixel pricteme +1 na odpovidajici pozici v histogramu.
    for i in range(x.shape[0]):
        for j in range(x.shape[1]):
            h[x[i,j]] += 1
    
    return h


# Nyni zobrazime histogramy pro kazdou slozku.
# Nejprve otevreme nove zobrazovaci okno (opetjako v jazyce Matlab).
plt.figure(2)
for i in range(3):
    h = histogram(bgr[:,:,2-i])
    
    # Histogramy zobrazime vedle sebe. 
    plt.subplot(1, 3, i+1)
    plt.plot(h)

# Jako posledni priklad si ukazeme vyhlazeni histogramu prostym prumerovanim.
# Histogram spocitame napr. ze sedotonoveho obrazku.
h = histogram(gray.astype(int))

# Zvolime sirku vyhlazovani K.
K = 2

# Vyhlazeny histogram ulozime do pole g. To nejprve inicializujeme na nulu.
g = np.zeros(h.shape[0])

# Do i-teho pole v g ulozime soucet prvku h[i-K:i+K] a vydelime poctem.
for i in range(h.shape[0]):
    g[i] = 0.
    # Opet: range(odkud, kam) nebude obsahovat koncovy bod.
    for j in range(-K, K+1):
        # Okrajove podminky osetrime jednoradkovym zapisem podminky if.
        g[i] += h[i+j] if i+j >= 0 and i+j < h.shape[0] else 0
    g[i] /= 2*K+1

# Histogramy zobrazime pres sebe - puvodni modre, vyhlazeny cervene.
plt.figure(3)
plt.plot(h, '-b')
plt.plot(g, '-r')
plt.show()