clc; clear all; close all;

load('filter_1.mat');
load('filter_2.mat');

% A = AA;B = BB;

[H, w] = freqz(B, A, 1000);
% w se normuje pi, aby byla normalni cisla
figure;plot(w/pi, abs(H))

figure;freqz(B,A,1000);

figure;phasedelay(B, A, 1000);

figure;stem(B);title('impulzni odezva');

% ctvercova vlna
% filtr jedna ma propustne pasmo 0.2pi
N = 1000;
n = 0:N-1;
x = zeros(size(N));
w_b = 0.02*pi;
frm = 1:200;
% cim vic k, tim vic sinusovek
for k = 1:5
    x = x + 4/pi*sin((2*k-1)*w_b*n)/(2*k-1);
end
figure;plot(n(frm), x(frm));

[X,w_ax] = dtft(x, 10*length(x), true);
figure;plot(w_ax/pi, abs(X));

y = filter(B, A, x);
dly = 20;
figure;plot(n(frm), x(frm));
hold on;plot(n(frm), y(dly+frm));

[Y, w_ax]=dtft(y, 10*length(x), true);
figure; plot(w_ax/pi, abs(Y));