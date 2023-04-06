clc; clear all; close all;
[doprovod, fs] = audioread("chtit jen malo doprovod.wav");
[zpev, fs] = audioread("chtit jen malo zpev bez delay a reverb.wav");
h = randn(1, fs);
h(2:200) = 0;
g = h .* (1./((1:fs).^0.6));
y = filter(g, 1, zpev);
soundsc(doprovod + y, fs)