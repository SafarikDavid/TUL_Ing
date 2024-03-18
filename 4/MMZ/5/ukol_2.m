% Úkol č. 2: Co je na obrázku?
% Rekonstruujte obrázek o velikosti 65x97 bodů z jeho komprimovaného záznamu y v souboru ukol2.mat. Vzorkující transformace je dána maticí A. Z numerického formátu uint8 převeďte A do formátu double.
clc; clear all; close all;
addpath l1magic-master\
addpath l1magic-master\Optimization\

load('ukol2.mat')
A = double(A);

x = OMP(A, y, 2000, []);
% 65*97
x = l1eq_pd(zeros(size(x)), A, [], y);

imshow(reshape(x, 65, 97))