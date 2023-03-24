clc; close all; clear all;

[x, x_fs] = audioread('TwoChannelMicrophoneArrayRecording.wav');

t = 0:1/x_fs:length(x)/x_fs - 1/x_fs;

subplot(3,1,1)
plot(t, x(:, 1))
title('channel 1')
subplot(3,1,2)
plot(t, x(:, 2))
title('channel 2')

rxy = xcorr(x(:, 1), x(:, 2));
x_l = size(x, 1);
lag_ax = -x_l+1:x_l-1;

subplot(3,1,3)
plot(lag_ax, rxy)

[mx, arg_mx] = max(rxy)
% x-ova souradnice maxima je lag
lmax = lag_ax(arg_mx)

% casovy posun v sekundach (lag)
TDOA = lmax*(1/x_fs)

% vzdalenost mikrofonu je 5 cm - tady v metrech
% vyjde v radianech - /(2*pi)*360 to prevede na stupne
DOA = asin(TDOA*343/0.055)/(2*pi)*360

% je zpozdeno o 3 vzorky - levy kanal musim totiz predsunout, takze zvuk
% jde z prava