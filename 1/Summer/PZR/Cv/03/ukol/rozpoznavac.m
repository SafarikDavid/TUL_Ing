clc; clear all; close all;

file_list = readlines("FileList_p2201.txt", "EmptyLineRule", "skip");
pocet_nahravek = length(file_list);

% coefficient selection
% 1 - ene
% 2 - ene + zcr
% 3 - spectrum
coefficient_select = 3;

% word boundary search parameters
bound_k_extremas = 10;
bound_threshold_percentage = 0.4;

% plot signal
plot_data = true;
% if plot_data false - sound_cutout won't activate
sound_cutout = true;

test_indexes = [];
train_indexes = [];

pocet_vzorku_v_segmentu = 400;
frame_len = 160;

for i = 1:pocet_nahravek
%     rozdeleni nahravek na trenovaci sadu a testovaci sadu
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

    [word_start, word_end, word_threshold] = FindWordBoundary(energy, bound_k_extremas, bound_threshold_percentage);

    cutout = x(frame_len*(word_start-1)+1:frame_len*word_end);
    cutout_frames = frames(:, word_start:word_end);
    cutout_energy = energy(word_start:word_end);

    zcr = ComputeZCR(cutout_frames);

    spectrum = ComputeSpectrum(cutout_frames, 512, 16);
%     imshow(mat2gray(spectrum./max(max(spectrum)), [0 0.1]))

    energy_coeff{i} = cutout_energy;
    energy_and_zcr_coeff{i} = [cutout_energy; zcr];
    spectral_coeff{i} = spectrum;
    
    if (abs(word_end - word_start) > 100)
        fprintf("Extreme boundary diff found %d: %s\n", abs(word_end - word_start), file_list(i))
    end

    if (plot_data == true)
        fprintf("Viewing: %s\n", file_list(i))
        close('all')
        subplot(2,1,1)
        t = 0:1/Fs:x_len/Fs - 1/Fs;
        plot(t, x)
        title("Signal after filter")
    
        subplot(2,1,2)
        plot(energy)
        title(strcat('energie: ', string(word_threshold)))
        hold on
        xline(word_start)
        xline(word_end)
        
        if (sound_cutout == true)
            soundsc(cutout, Fs)
        end

        %     pozdrzeni programu
        w = waitforbuttonpress;
    end
end

if (coefficient_select == 1)
    coeff = energy_coeff;
elseif (coefficient_select == 2)
    coeff = energy_and_zcr_coeff;
elseif (coefficient_select == 3)
    coeff = spectral_coeff;
end
predictions = zeros(length(test_indexes), 1);
ground_truth = zeros(length(test_indexes), 1);
for i = 1:length(test_indexes)
    test_coeff = coeff{test_indexes(i)};
    P = size(test_coeff, 1);
    I = size(test_coeff, 2);
    min_dist_index = 1;
    min_dist = 1e100;
    for j = 1:length(train_indexes)
        train_coeff = coeff{train_indexes(j)};
        J = size(train_coeff, 2);
        dist = ComputeLTW(test_coeff, I, train_coeff, J, P);
        if (dist < min_dist)
            min_dist = dist;
            min_dist_index = j;
        end
    end
    prediction = file_list(train_indexes(min_dist_index));
    prediction = convertStringsToChars(prediction);
    predictions(i) = str2num(prediction(end-14));
    truth = file_list(test_indexes(i));
    truth = convertStringsToChars(truth);
    ground_truth(i) = str2num(truth(end-14));
end

accurracy = sum(predictions == ground_truth)/length(predictions) * 100;

fprintf("Accurracy: %.2f\n", accurracy)