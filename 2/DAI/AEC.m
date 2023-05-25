clc; clear all; close all;

% s_orig ... původní hlas mluvčího (near end)
% s ... hlas mluvčího snímaný čtyřmi mikrofony
% v ... hlas interferujícího řečníka (far end)
% echo ... akustická odezva interferujícího řečníka na čtyřech mikrofonech (které používá "náš" mluvčí)
% x = s + echo ... signály, které mikrofony reálně snímají

load AEC_uloha.mat

% u = 0.1
% nfft = 512
% shift(overlap) 50%
% hamming
u = 0.001;
nfft = 512;
overlaplen = floor(0.75*nfft);
window = hamming(nfft);

X = stft(x(:, 1), Fs, Window=window, OverlapLength=overlaplen, FFTLength=nfft);
V = stft(v(:, 1), Fs, Window=window, OverlapLength=overlaplen, FFTLength=nfft);
% imagesc(log(abs(X)))

H = ones(nfft, 1);
E = zeros(size(X));
for t = 1:10
for i = 1:size(X, 2)
%     u = (1/log(sum(abs(V(:,i)).^2)))*0.01;
    E(:, i) = X(:, i) - H.*V(:, i);
    H = H + u*(E(:, i).*X(:, i)) ./ (abs(X(:, i)).^2 + 0.001);
end
end

e = istft(E, Fs, Window=window, OverlapLength=overlaplen, FFTLength=nfft);
plot(e)