function [word_start,word_end,word_threshold] = FindWordBoundary(energy, k_extremas, boundary_percentage, boundary_shift)
%     hledani prumeru energie
min_energy_frames = mink(energy, k_extremas);
mean_min_energy = mean(min_energy_frames);

max_energy_frames = maxk(energy, k_extremas);
mean_max_energy = mean(max_energy_frames);

word_threshold = mean_min_energy + abs(mean_max_energy - mean_min_energy) * boundary_percentage;

%     hledani zacatku a konce slova
word_start = 1;
word_end = length(energy);
while (energy(word_start)) < word_threshold
    word_start = word_start + 1;
end
while (energy(word_end)) < word_threshold
    word_end = word_end - 1;
end
% posunuti zacatku a konce
word_start = max(word_start - boundary_shift, 1);
word_end = min(word_end + boundary_shift, length(energy));
end

