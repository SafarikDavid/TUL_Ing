clc; clear all; close all;

load("Tones.mat")
% select instrument -------------------------------------------------------
samples = noteFlute;
% select instrument -------------------------------------------------------

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
notes = [10 1 3];
% 1 - cela, 1/2 - pulova, 1/4 - ctvrtova
durations = [1/4 1/2 1/4];
% octave shift - must be either (-1, 0, 1)
octave_shift = [0 0 0];
% tempo 60 je cela nota na vterinu
tempo = 60;

% whole note duration in samples
whole_note_duration = fsNew;

melody = [];
for i = 1:length(notes)
    % find tone index
    tone_idx = notes(i);
    % get tone sample
    tone = samples{tone_idx};
    % octave shift - resampling
    if octave_shift(i) == -1
        tone = resample(tone, 2, 1);
    end
    if octave_shift(i) == 1
        tone = resample(tone, 1, 2);
    end

    tone_len = length(tone);
    % calculate note duration in samples based on tempo and note duration
    dur_samples = floor((whole_note_duration/(tempo/60))*durations(i));
    % repeats signal, should the note be longer than the base length of
    % signal
    if dur_samples > tone_len
        temp = [];
        % window to eliminate clicks, but creates unwanted silence in the
        % middle of a single tone
        window = tukeywin(length(tone), 0.01)';
        for j = 1:ceil(dur_samples/tone_len)
            if rem(j, 2) == 0
                temp = [temp flip(tone).*window];
            else
                temp = [temp tone.*window];
            end
        end
        tone = temp;
        % tone = filter(ones(1, 2)/2, 1, temp);
    end
    % select only desired duration of tone
    tone = tone(1:dur_samples);
    % window function to eliminate clicks
    tone = tone.*tukeywin(length(tone), 0.2)';
    % concatenate tone to melody signal
    melody = [melody tone];
end

% add RIR and stereo
[h_r, fs] = audioread("W25x20y.wav");
h_r = resample(h_r, 1, fs/fsNew);
[h_l, fs] = audioread("W35x20y.wav");
h_l = resample(h_l, 1, fs/fsNew);
stereoMelody = [filter(h_l, 1, melody); filter(h_r, 1, melody)];

% play melody
soundsc(stereoMelody, fsNew)