function [zcr] = ComputeZCR(frames)
zcr = [];
for i = 1:size(frames, 2)
    segment = frames(:, i);
    zcr_temp = 0;
    for j = 2:length(segment)
        zcr_temp = zcr_temp + abs(sign(segment(j)) - sign(segment(j-1)));
    end
    zcr = [zcr zcr_temp/(2*(size(frames, 1)-1))];
%     zcr = [zcr zcr_temp/2];
end
end

