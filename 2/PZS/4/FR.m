clc; clear all; close all;

N = 100;
n = 0:N-1;
x = cos(pi/2*n);

figure
stem(n, x)

y = filter([1 1 1]./3, [1], x);

hold on

% prechodovy jev - je tam u y
% je to takovy trhnuti
stem (n, y)