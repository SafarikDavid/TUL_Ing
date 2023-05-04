clc; clear all; close all;

% analyza trans, rekon sig pomoci banky filtru
[x, x_fs] = audioread('zpěv dívka.wav');
x = x(:, 1);

load("untitled.mat")
h = Num;
N = 256;
for k = 0:N-1
    hk = h.*exp(1i*2*pi*k*(0:length(h)-1)/N);
    X(:, k+1) = filter(hk, 1, x);
end

imagesc(log(abs(X)))

y = mean(X, 2);
figure;plot(real(y)/max(abs(real(y))));
hold on;plot(x);
soundsc(real(y)/max(abs(real(y))));
% hold on;plot(imag(y));

% soundsc(real(X(:,1)));