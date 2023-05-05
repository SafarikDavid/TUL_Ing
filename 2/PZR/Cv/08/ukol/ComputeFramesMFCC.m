function [cep_coeff,mel_fbank] = ComputeFramesMFCC(frames, N, M, Fs)
cep_coeff = zeros(M, size(frames, 2));
mel_fbank = zeros(N, size(frames, 2));
for i = 1:size(frames, 2)
    [cep_coeff(:, i), mel_fbank(:, i)] = computeFrameMFCC(frames(:, i), N, M, Fs);
end
end

