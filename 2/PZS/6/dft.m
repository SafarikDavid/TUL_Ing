clc; clear all; close all;

N = 256;
% w = 2*pi*64;
w = pi/4;
f_s = 16000;

n = 0:N-1;
x = cos(w*n);
X = fft(x);

k = n;
w_ax = 2*pi*k/N;
f_ax = f_s*k/N;
% vzorkova osa - k
figure
stem(abs(X))
xlabel("k")
% frekvence na ose
figure
stem(f_ax, abs(X))
xlabel("F")
% 0 - 2pi
figure
stem(w_ax/pi, abs(X))
xlabel("w")