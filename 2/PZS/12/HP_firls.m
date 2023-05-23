clc; clear all; close all;

% N = 120;
N = 86;
d_s = 2e-4;
d_p = 1e-3;
f = [0 0.7 0.8 1]; % 0 a 1 jako hranicni
a = [0 0 1 1];
w = 1./[d_s d_p];
b = firls(N, f, a, w);

[H, w] = freqz(b, 1, 1000);
figure; plot(w/pi, abs(H));