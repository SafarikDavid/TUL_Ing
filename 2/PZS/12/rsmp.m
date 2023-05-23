clear all; close all; clc; 

des_fs = 16000;

[x, x_fs] = audioread("speech_48k.wav");

load filterDP_Kaiser03.mat

y = filter(b, 1, x);
ph_d = 30;
y = [y(ph_d+1:end);zeros(ph_d,1)];

y2 = y(1:3:end);

y_mtlb = resample(x, des_fs, x_fs);

sqr_err = sum((y2-y_mtlb).^2)