clear all;
close all;
clc;

n=1:1e3;
x = sin(pi/4*n) .* cos(pi/3*n);
% x = cos(n*pi/3);
%x = ones(1,n(end));
%x = 0.5.^n;
%x = randn(size(n));
x = x + randn(size(n));

[H, W] = dtft(x, 10*n(end)+1);
figure;
plot(W/pi,abs(H)/pi);
xlabel('\omega/\pi [ rad/sample]');
ylabel('|X(e^{j\omega})|');