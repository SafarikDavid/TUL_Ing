clc; clear all; close all;

load("synch_prum.mat")

plot(x1)
hold on
plot(x2)
plot(x3)
plot(x4)
plot(x5)

hold off

figure()

plot(xcorr(x1, x2))