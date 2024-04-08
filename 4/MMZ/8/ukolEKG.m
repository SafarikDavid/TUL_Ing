% Úkol: PCA signálů z EKG
% Proveďte Analýzu hlavních a nezávislých komponent na signály v souborech.
% Rekonstruujte data z vybraných komponent.

clc; clear all; close all;

load("EKG3channels_sinus.mat")

Cx = x*x'/size(x, 2);

[V, D] = eig(Cx);

% V^H je transpozice
Z = V'*x;

% vykresleni Z
figure()
subplot(3, 1, 1)
plot(Z(1, :))

subplot(3, 1, 2)
plot(Z(2, :))

subplot(3, 1, 3)
plot(Z(3, :))

% vynulujeme treti komponentu
% tam je sum, a je to nejsilnejsi vlastni vektor, protoze sum je silnej
Z(3, :) = Z(3, :)*0;

% rekonstrukce signalu
X = V*Z;

figure()
% vykresleni puvodnich dat a rekonstruovanych
subplot(3, 1, 1)
plot(x(1, :))
hold on
plot(X(1, :))

subplot(3, 1, 2)
plot(x(2, :))
hold on
plot(X(2, :))

subplot(3, 1, 3)
plot(x(3, :))
hold on
plot(X(3, :))