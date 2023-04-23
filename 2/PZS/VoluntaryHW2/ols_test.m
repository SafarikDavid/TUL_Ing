clc; clear all; close all;

rng(1);
maxNumCompThreads(1);

% vytvoreni signalu
N = 1e8;
x = randn(N, 1);
% vytvoreni impulzni odezvy
L = 8e3;
h = randn(L, 1);

fprintf("Matlab conv:\n")
tic
y = conv(x, h);
toc

fprintf("\nOverlap save:\n")
tic
y2 = my_ols(x, h);
toc

l_y = length(y);
l_y2 = length(y2);
min_l_y = min(l_y, l_y2);
fprintf("\nLength diff: %d\n", abs(l_y2 - l_y))

err = sum((y(1:min_l_y) - y2(1:min_l_y)).^2);
fprintf("\nComputation err: %e\n", err)
