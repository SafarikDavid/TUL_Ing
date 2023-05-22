%% LP
clear all; close all; clc;

L = 129;
w_s1 = 0.4*pi;
w_p1 = 0.3*pi;

w_c = (w_s1+w_p1)/2;

[~, ~, beta, ~] = kaiserord([w_p1 w_s1], [1 0], [0.0002 0.00001], 2*pi);
win = kaiser(L, beta)';

N = L - 1;
n = 0:N;

h_LP = w_c/pi*sinc(w_c*(n-0.5*N)/pi);
h_LP = h_LP.*win;

%% HP

w_s2 = 0.6*pi;
w_p2 = 0.7*pi;

w_c = (w_s2+w_p2)/2;

[~, ~, beta, ~] = kaiserord([w_s2 w_p2], [0 1], [0.00001 0.0002], 2*pi);
win = kaiser(L, beta)';

N = L - 1;
n = 0:N;

dlt = zeros(size(n));
dlt(N/2+1) = 1;
h_HP = dlt - w_c/pi*sinc(w_c*(n-0.5*N)/pi);
h_HP = h_HP.*win;

%% bandstop

h = h_LP + h_HP;
[H, w] = freqz(h,1,1000);
figure; plot(w/pi, abs(H));