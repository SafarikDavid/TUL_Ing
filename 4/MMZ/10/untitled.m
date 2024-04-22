clc; clear all; close all;

D = diag(2:6)^2

x = [5;5;5;5;5];

res = D*x % is basically element-wise multiplication

% zfiltrovani signalu - vyhlazeni
x = randn(1, 1000);
X = dftmtx(1000)*x';

X(4:end-2) = 0;

y = dftmtx(1000)'*X;

plot(y);
hold on
plot(x);