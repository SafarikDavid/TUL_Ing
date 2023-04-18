clear all; clc; close all;

[x, x_fs] = audioread('DTMF.wav');

n = 0:length(x) - 1;
% plot(n, x);

win_len = 400;
nfft_len = 2*win_len;
% spectrogram(x, win_len, 0, win_len, x_fs, 'yaxis'); colormap jet;
figure
spectrogram(x, hamming(win_len), 0, nfft_len, x_fs, 'yaxis'); colormap jet;
X = spectrogram(x, hamming(win_len), 0, nfft_len, x_fs, 'yaxis');

f_ax = (0:(nfft_len/2))*x_fs/nfft_len;

for lp = 1:size(X, 2)
    figure;
    findpeaks(abs(X(:, lp)), f_ax, 'MinPeakProminence', 2);
end