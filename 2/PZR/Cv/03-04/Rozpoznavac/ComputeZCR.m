function [zcr] = ComputeZCR(frames)
zcr = zeros(1, size(frames, 2));
for i = 1:size(frames, 2)
    segment = frames(:, i);
    zcr_temp = sum(abs(sign(segment(2:end)) - sign(segment(1:end-1))));
    zcr(i) = zcr_temp/2;
end
end

