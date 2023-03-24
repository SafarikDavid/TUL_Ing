function [frames, energy] = ComputeFramesAndEnergy(sig, frame_len, frame_overlap)
sig_len = length(sig);

%     doplneni o nuly kvuli velikosti framu
sig_with_zeros = [sig; zeros(frame_len, 1)];

frames = [];
energy = [];

for frame_start = 1:frame_overlap:sig_len
    segment = sig_with_zeros(frame_start:frame_start+frame_len-1);
    frames = [frames segment];
    energy = [energy log(dot(segment, segment))];
end
end

