clc; clear all; close all;

% notch filter; f0 = 32 Hz; fs = 512 Hz;
sig_len = 10;
f0 = 32;
fs = 512;
w0 = 2*pi*f0/fs;
frqs = [8, 16, 32, 64];
f_N = length(frqs);
% na elearning, tohle je blbe
frm = 0.5*fs:(fs*sig_len)+1;

b = poly([exp(1i*w0), exp(-1i*w0)]);
a = poly(0.99*[exp(1i*w0), exp(-1i*w0)]); %cim vic 0.99999999, tim uzsi

k = sum(b)/sum(a); % tohle je v bode nula hodnota
b = b/k; %normalizace

[H, w] = freqz(b, a, 1000);
figure; plot(w/pi, abs(H));
figure; zplane(b, a);


t = ((0:fs*sig_len-1)/fs)';
s = zeros(size(t));
for lp = 1:f_N
    s = s + cos(2*pi*frqs(lp)*t);
end

s_sp = fft(s(frm));
sp_N = length(s_sp);
k_ax = 0:sp_N - 1;
w_ax = fs*k_ax/sp_N;

figure; stem(w_ax, abs(s_sp));

y = filter(b, a, s);
y_sp = fft(y(frm));
figure; stem(w_ax, abs(y_sp));