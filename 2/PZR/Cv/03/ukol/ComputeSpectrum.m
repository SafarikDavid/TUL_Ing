function [out] = ComputeSpectrum(frames, fft_len, K)
out = [];
for i = 1:size(frames, 2)
    segment = frames(:, i);
    segment = [segment; zeros(fft_len - length(segment), 1)];
    segment = segment .* hamming(fft_len)';
    spectrum = fft(segment, fft_len);
    amp_spectrum = abs(spectrum(1:fft_len/2));
    spectral_coefficients = [];
    for k = 1:K:fft_len/2
        spectral_coefficients = [spectral_coefficients; mean(amp_spectrum(k:k+K-1))];
    end
    out = [out spectral_coefficients];
end
end

