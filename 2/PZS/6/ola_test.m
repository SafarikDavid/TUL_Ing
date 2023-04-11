clc; clear all; close all;

rng(1);
maxNumCompThreads(1);

rep_num = 20;
L = 4000;
[s, s_fs] = audioread('waltz.wav');
s = s(:, 1);
% zopakovani signalu, pro prodlouzeni
x = repmat(s, rep_num, 1);

h = randn(L, 1);

tic
y = conv(x, h);
toc
tic
y2 = my_ola(x, h);
toc

sum((y - y2).^2)