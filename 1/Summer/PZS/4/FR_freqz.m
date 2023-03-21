clc; clear all; close all;

% frekvencni char moving average filtru
[H, w] = freqz([1/3 1/3 1/3], [1], 1000);
plot(w/pi, abs(H))