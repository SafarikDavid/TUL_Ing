clc; clear all; close all;

load('foetalECG.mat')
x = foetal_ecg(:, 2:end)';

brisni = x(1:3, :);
hrudni = x(6:8, :);
W = efica(x, eye(8));

Y = W*x;

komponent = 6;
Y(komponent, :) = Y(komponent, :) * 0;
komponent = 7;
Y(komponent, :) = Y(komponent, :) * 0;
komponent = 8;
Y(komponent, :) = Y(komponent, :) * 0;
komponent = 2;
Y(komponent, :) = Y(komponent, :) * 0;
komponent = 1;
Y(komponent, :) = Y(komponent, :) * 0;
komponent = 4;
Y(komponent, :) = Y(komponent, :) * 0;

X = W\Y;

figure()
subplot(321)
plot(X(1, :))
subplot(323)
plot(X(2, :))
subplot(325)
plot(X(3, :))

subplot(322)
plot(brisni(1, :))
subplot(324)
plot(brisni(2, :))
subplot(326)
plot(brisni(3, :))