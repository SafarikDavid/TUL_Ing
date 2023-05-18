clc; clear all; close all;

fs = 16000;
load('dukaz_superpozice_zvuku.mat')

% x = oba najednou
% s1 = jeden
% s2 = druhej

x2 = s1+s2;

sum((x(:)-x2(:)).^2)

mean(abs(x(:) - s1(:) - s2(:)))