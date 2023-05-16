%% HP
clear all; close all; clc;

L = 81;
w_s = 0.3*pi;
w_p = 0.2*pi;

w_c = (w_s+w_p)/2;
win = hamming(L)';

N = L - 1;
n = 0:N;

h = w_c/pi*sinc(w_c*(n-0.5*N)/pi);
h = h.*win;
[H, w] = freqz(h,1,1000);
figure; plot(w/pi, abs(H));
figure; phasedelay(h, 1, 1000);

%% LP
clear all; close all; clc;

L = 121;
w_s = 0.7*pi;
w_p = 0.8*pi;

w_c = (w_s+w_p)/2;
win = blackman(L)';

N = L - 1;
n = 0:N;

dlt = zeros(size(n));
dlt(N/2+1) = 1;
figure; stem(n, dlt);
h = dlt - w_c/pi*sinc(w_c*(n-0.5*N)/pi);
h = h.*win;
[H, w] = freqz(h,1,1000);
figure; plot(w/pi, abs(H));
figure; phasedelay(h, 1, 1000);