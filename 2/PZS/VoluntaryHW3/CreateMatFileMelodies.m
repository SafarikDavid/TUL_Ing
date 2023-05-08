% 1 = C5
% 2 cis
% 3 d
% 4 dis
% 5 e
% 6 f
% 7 fis
% 8 g
% 9 gis
% 10 a
% 11 ais
% 12 b
notes = [8 8 5, 8 8 5, 8 8 10 8, 8 6, 6 6 3, 6 6 3, 6 6 8 6, 6 5];
% 1 - cela, 1/2 - pulova, 1/4 - ctvrtova
durations = [1/4 1/4 1/2, 1/4 1/4 1/2, 1/4 1/4 1/4 1/4, 1/2 1/2, 1/4 1/4 1/2, 1/4 1/4 1/2, 1/4 1/4 1/4 1/4, 1/2 1/2];
% octave shift - must be either (-1, 0, 1)
octave_shift = [0 0 0, 0 0 0, 0 0 0 0, 0 0, 0 0 0, 0 0 0, 0 0 0 0, 0 0];
% tempo 60 je cela nota na vterinu
tempo = 60;

save("SkakalPes.mat", "tempo", "octave_shift", "durations", "notes");

% 1 = C5
% 2 cis
% 3 d
% 4 dis
% 5 e
% 6 f
% 7 fis
% 8 g
% 9 gis
% 10 a
% 11 ais
% 12 b
notes = [10 1 3, 5 6 5, 3 12, 8 10 12, 1 10, 10 9 10, 12 9, 5 10, 1 3, 5 6 5, 3 12, 8 10 12, 1 12 10, 9 7 9, 10, 10];
% 1 - cela, 1/2 - pulova, 1/4 - ctvrtova
durations = [1/4 1/2 1/4, 3/8 1/8 1/4, 1/2 1/4, 3/8 1/8 1/4, 1/2 1/4, 3/8 1/8 1/4, 1/2 1/4, 1/2 1/4, 1/2 1/4, 3/8 1/8 1/4, 1/2 1/4, 3/8 1/8 1/4, 3/8 1/8 1/4, 3/8 1/8 1/4, 3/4, 3/4];
% octave shift - must be either (-1, 0, 1)
octave_shift = [-1 0 0, 0 0 0, 0 -1, -1 -1 -1, 0 -1, -1 -1 -1, -1 -1, -1 -1, 0 0, 0 0 0, 0 -1, -1 -1 -1, 0 -1 -1, -1 -1 -1, -1, -1];
% tempo 60 je cela nota na vterinu
tempo = 46;

save("Greensleeves.mat", "tempo", "octave_shift", "durations", "notes");