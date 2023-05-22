%% filter designer
% hamming window
% LPX - X = order
clc; clear all; close all;

load LP10.mat; load LP20.mat; load LP40.mat; load LP80.mat; load LP160.mat; load LP320.mat;


[H, w] = freqz(LP10,1,1000);
plot(w/pi, abs(H));
hold on;

[H, w] = freqz(LP20,1,1000);
plot(w/pi, abs(H));
[H, w] = freqz(LP40,1,1000);
plot(w/pi, abs(H));
[H, w] = freqz(LP80,1,1000);
plot(w/pi, abs(H));
[H, w] = freqz(LP160,1,1000);
plot(w/pi, abs(H));
[H, w] = freqz(LP320,1,1000);
plot(w/pi, abs(H));

legend("LP10", "LP20", "LP40", "LP80", "LP160", "LP320")

%% rucne
clc; clear all; close all;

Ls = [10 20 40 80 160 320];
w_s = 0.3*pi;
w_p = 0.2*pi;

w_c = (w_s+w_p)/2;

figure; hold on;

for i = 1 : length(Ls)
    L = Ls(i);

    win = hamming(L)';
    
    N = L - 1;
    n = 0:N;
    
    h = w_c/pi*sinc(w_c*(n-0.5*N)/pi);
    h = h.*win;

    [H, w] = freqz(h,1,1000);
    plot(w/pi, abs(H));
end

legend("LP10", "LP20", "LP40", "LP80", "LP160", "LP320")