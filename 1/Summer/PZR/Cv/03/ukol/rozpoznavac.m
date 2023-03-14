clc; clear all; close all;

file_list = readlines("file_list.txt");
pocet_nahravek = length(file_list);

test_indexes = [];
train_indexes = [];

pocet_vzorku_v_segmentu = 400;
frame_len = 160;

for i = 1:pocet_nahravek
    if(contains(file_list(i), 's01.wav'))
        train_indexes = [train_indexes i];
    else
        test_indexes = [test_indexes i];
    end

    [x, Fs] = audioread(file_list(i), "native");
    x_len = length(x);

%     add noise
    x = x + (randi(3, 32000, 1, 'int16') -2);
%     filter
    x = filter([1 -0.97], 1, x);

    [frames, energy] = ComputeFramesAndEnergy(x, pocet_vzorku_v_segmentu, frame_len);

    [word_start, word_end] = FindWordBoundary(energy, 5, 0.9);

    cutout = x(frame_len*(word_start-1)+1:frame_len*word_end);
    cutout_frames = frames(:, word_start:word_end);
    cutout_energy = energy(word_start:word_end);

    zcr = ComputeZCR(cutout_frames);

    spectrum = ComputeSpectrum(cutout_frames, 512, 16);
%     imshow(mat2gray(spectrum./max(max(spectrum)), [0 0.1]))

    energy_coeff{i} = cutout_energy;
    energy_and_zcr_coeff{i} = [cutout_energy; zcr];
    spectral_coeff{i} = spectrum;

%     pozdrzeni programu
%     w = waitforbuttonpress;
end