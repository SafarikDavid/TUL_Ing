% Odstranění šumu z EKG
% Odstraňte síťový šum ze signálu v souboru EKG3channels_sinus.mat pomocí libovolné ICA metody.

clc; clear all; close all;

load('EKG3channels_sinus.mat')

W = efica(x, eye(3));

Y = W*x;

komponent = 1;
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
plot(x(1, :))
subplot(324)
plot(x(2, :))
subplot(326)
plot(x(3, :))