clc; clear all; close all;

load("Tones.mat")



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
% octave shift
octave = [0 0 0, 0 0 0, 0 0 0 0, 0 0, 0 0 0, 0 0 0, 0 0 0 0, 0 0];
% tempo 60 je cela nota na vterinu
% musi byt aspon 60
tempo = 60;
melody = [];
samples = noteFlute;

whole_note_dur = fsNew;

for i = 1:length(notes)
    note_idx = notes(i);
    tone = samples{note_idx};
    if octave(i) == -1
        tone = resample(tone, 2, 1);
    end
    if octave(i) == 1
        tone = resample(tone, 1, 2);
    end
    tone_len = length(tone);
    dur_samples = floor((whole_note_dur/(tempo/60))*durations(i));
    if dur_samples > tone_len
        temp = [];
        window = tukeywin(length(tone), 0.1)';
        for j = 1:ceil(dur_samples/tone_len)
            if rem(j, 2) == 0
                temp = [temp flip(tone).*window];
            else
                temp = [temp tone.*window];
            end
            
        end
        tone = temp;
        tone = filter(ones(1, 2)/2, 1, temp);
    end
    tone = tone(1:dur_samples);
    tone = tone.*tukeywin(length(tone), 0.1)';
    melody = [melody tone];
end

[h1, fs] = audioread("W25x20y.wav");
h1 = resample(h1, 1, fs/fsNew);
[h2, fs] = audioread("W35x20y.wav");
h2 = resample(h2, 1, fs/fsNew);

stereoMelody = [filter(h1, 1, melody); filter(h2, 1, melody)];

soundsc(stereoMelody, fsNew)