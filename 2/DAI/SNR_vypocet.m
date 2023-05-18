%% per vzorek - okynka
clc; clear all; close all;

load rec_autobus.mat

SNR_val = sum(s.^2)/sum(v.^2);
log_SNR = 10*log10(SNR_val);

% L = 160;
L = 1600;
for i = 1:floor(length(s)/L)
    k = ((i-1)*L)+1;
    SNR(i) = sum(s(k:k+L-1).^2)/sum(v(k:k+L-1).^2);
end

plot(10*log10(SNR))

%% per frekvence
clc; clear all; close all;

load("rec_autobus.mat")

NFFT = 256;
N_Overlap = 32;

[S, S_f] = stft(s, Fs, "FFTLength", NFFT, "OverlapLength", N_Overlap, 'FrequencyRange','onesided');
[V, V_f] = stft(v, Fs, "FFTLength", NFFT, "OverlapLength", N_Overlap, 'FrequencyRange','onesided');

SNR = sum(abs(S).^2, 2)./sum(abs(V).^2, 2);

plot(S_f, 10*log10(SNR))
xlabel("frequency")
ylabel("10*log10(x)")