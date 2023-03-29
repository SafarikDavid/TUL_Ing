function [out] = ComputeSpectrum(frames, fft_len, K)
segments = [frames; zeros(fft_len - size(frames, 1), size(frames, 2))];
segments = segments .* hamming(fft_len);
spectrum = fft(segments, fft_len);
amp_spectrum = abs(spectrum(1:fft_len/2, :));
out = [];
for k = 1:K:fft_len/2
    out = [out; mean(amp_spectrum(k:k+K-1, :))];
end
end
