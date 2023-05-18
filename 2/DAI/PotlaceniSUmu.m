clc; clear all; close all;

load speech_bus_two_mics.mat
NFFT = 256;
N_Overlap = 32;

[X_mic2, X_mic2_f] = stft(x_mic2, fs, "FFTLength", NFFT, "OverlapLength", N_Overlap, 'FrequencyRange','onesided');
[X_mic1, X_mic1_f] = stft(x_mic1, fs, "FFTLength", NFFT, "OverlapLength", N_Overlap, 'FrequencyRange','onesided');
[S_mic2, S_mic2_f] = stft(s_mic2, fs, "FFTLength", NFFT, "OverlapLength", N_Overlap, 'FrequencyRange','onesided');
[S_mic1, S_mic1_f] = stft(s_mic1, fs, "FFTLength", NFFT, "OverlapLength", N_Overlap, 'FrequencyRange','onesided');
[V_mic2, V_mic2_f] = stft(v_mic2, fs, "FFTLength", NFFT, "OverlapLength", N_Overlap, 'FrequencyRange','onesided');
[V_mic1, V_mic1_f] = stft(v_mic1, fs, "FFTLength", NFFT, "OverlapLength", N_Overlap, 'FrequencyRange','onesided');
% W = (abs(S_mic1).^2)./((abs(S_mic1).^2)+(abs(V_mic1).^2));
% W = max((abs(X_mic1).^2-abs(V_mic1).^2), 0)./((abs(X_mic1).^2)+0.000001);
% W = max((abs(X_mic1).^2-abs(V_mic2/2).^2), 0)./((abs(X_mic1).^2)+0.000001);
W = max((abs(X_mic1).^2-abs(V_mic2).^2), 0)./((abs(X_mic1).^2)+0.000001);
% W(W<0.6) = 0;

Y = W.*X_mic1;
Y_S = W.*S_mic1;
Y_V = W.*V_mic1;

SNR_in = sum(abs(S_mic1(:)).^2)/sum(abs(V_mic1(:)).^2);
SNR_out = sum(abs(Y_S(:)).^2)/sum(abs(Y_V(:)).^2);
log_SNR_in = 10*log10(SNR_in);
log_SNR_out = 10*log10(SNR_out);

y = istft(Y, fs, "FFTLength", NFFT, "OverlapLength", N_Overlap, 'FrequencyRange','onesided');

figure;imagesc(W)
figure;imagesc(log(abs(S_mic1)))