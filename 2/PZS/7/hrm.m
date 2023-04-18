clc; close all; clear all;

load("Signal.mat");

% plot(x)

N = length(x);
% na tenhle signal dobrej blackman protoze slaba komponenta blizko silny
% rect by ji moc potlacil
win = blackman(N)';

% win = kaiser(N, 10)';

y = x.*win;

% doplneni nulama na 2*delka
nfft = 2*N;
Y = fft(y, nfft);
figure;
k = 0:nfft -1;
w_ax = 2*pi*k/nfft;
% log je kvuli preskalovani a lepsimu rozliseni
% prevod do decibel
stem(w_ax/pi, 20*log10(abs(Y)))