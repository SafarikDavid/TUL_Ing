clc; clear all; close all;

% kazdy soubor je jeden clovek, lze zadat pouze jednu cestu
list_of_file_lists = [
    "FileList_p2101.txt";
    "FileList_p2102.txt";
    "FileList_p2103.txt";
    "FileList_p2104.txt";
    "FileList_p2105.txt";
    "FileList_p2106.txt";
    "FileList_p2109.txt";
    "FileList_p2110.txt";
    "FileList_p2111.txt";
    "FileList_p2112.txt";
    "FileList_p2201.txt";
    "FileList_p2202.txt";
    "FileList_p2203.txt";
    "FileList_p2204.txt";
    "FileList_p2206.txt";
    "FileList_p2207.txt";
    "FileList_p2301.txt";
    "FileList_p2303.txt";
    "FileList_p2304.txt";
    "FileList_p2305.txt";
    "FileList_p2306.txt";
    "FileList_p2307.txt";
    "FileList_p2308.txt";
    ];

% pocet osob
n_persons = length(list_of_file_lists);

% ↓---------------------------nastaveni----------------------------------↓

% coefficient selection
% 1 - ene
% 2 - ene + zcr
% 3 - spectrum
coefficient_select = [1 2 3];

% plot signal settings
% sound_cutout will be reached only if plot_data is true
plot_data = false;
play_cutout = true;

% nastaveni vypisu do konzole
write_to_console = false;
write_suspicious_data_to_console = false;

% export settings
export_to_csv = true;
export_to_mat = false;

% spectrum settings
window_length = 512;
K_value = 16;

% word boundary search settings
bound_k_extremas = 10;
bound_threshold_percentage = 0.4;

% nastaveni segmentace
pocet_vzorku_v_segmentu = 400;
frame_len = 160;

% ↑---------------------------nastaveni----------------------------------↑

% prealokace poli pro vysledky
results_spectrum = zeros(1, n_persons);
results_ene_zcr = zeros(1, n_persons);
results_ene = zeros(1, n_persons);

for i_lists = 1:n_persons

% nacteni cest pro nahravky
file_list_name = list_of_file_lists(i_lists);
file_list = readlines(file_list_name, "EmptyLineRule", "skip");
n_recordings = length(file_list);

% nacteni cisla osoby
person = file_list(1);
person = convertStringsToChars(person);
person = convertCharsToStrings(person(end-12:end-8));

% vypis cisla osoby
if write_to_console
fprintf("-----------------------------------------\nPerson: %s\n", person)
end

test_indexes = [];
train_indexes = [];

for i = 1:n_recordings
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

    spectrum = ComputeSpectrum(cutout_frames, window_length, K_value);

    energy_coeff{i} = cutout_energy;
%     normalizace energie + zcr
    energy_and_zcr_coeff{i} = [cutout_energy./max(cutout_energy); zcr./max(zcr)];
    spectral_coeff{i} = spectrum;
    
    if (abs(word_end - word_start) > 100) && write_suspicious_data_to_console
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
        
        if (play_cutout == true)
            soundsc(cutout, Fs)
        end

        %     pozdrzeni programu
        w = waitforbuttonpress;
    end
end

for coeff_sel_index = 1:length(coefficient_select)
    select = coefficient_select(coeff_sel_index);
    coeff_name = "";
    switch select
        case 1
            coeff = energy_coeff;
            coeff_name = "Ene";
        case 2
            coeff = energy_and_zcr_coeff;
            coeff_name = "Ene+ZCR";
        case 3
            coeff = spectral_coeff;
            coeff_name = "Spectrum";
    end
    
    predictions = zeros(length(test_indexes), 1);
    ground_truth = zeros(length(test_indexes), 1);
    for i = 1:length(test_indexes)
        test_index = test_indexes(i);
        test_coeff = coeff{test_index};
    
        truth = file_list(test_index);
        truth = convertStringsToChars(truth);
        ground_truth(i) = str2num(truth(end-14));
    
        P = size(test_coeff, 1);
        I = size(test_coeff, 2);
        min_dist_index = 1;
        min_dist = 1e100;
        for j = 1:length(train_indexes)
            train_index = train_indexes(j);
            train_coeff = coeff{train_index};
            J = size(train_coeff, 2);
            dist = ComputeLTW(test_coeff, I, train_coeff, J, P);
            if (dist < min_dist)
                min_dist = dist;
                min_dist_index = j;
            end
        end
    
        prediction_index = train_indexes(min_dist_index);
        prediction = file_list(prediction_index);
        prediction = convertStringsToChars(prediction);
        predictions(i) = str2num(prediction(end-14));
    end
    
    accurracy(coeff_sel_index) = sum(predictions == ground_truth)/length(predictions) * 100;
    
    if write_to_console
    fprintf("Coeff: %s, Accurracy: %.2f\n", coeff_name, accurracy(coeff_sel_index))
    end

    switch select
        case 1
            results_ene(i_lists) = accurracy(coeff_sel_index);
        case 2
            results_ene_zcr(i_lists) = accurracy(coeff_sel_index);
        case 3
            results_spectrum(i_lists) = accurracy(coeff_sel_index);
    end
end
persons(i_lists) = person;
end
if (export_to_mat == true)
    save('results.mat', "persons", "results_spectrum", "results_ene_zcr", "results_ene")
end

if (export_to_csv == true)
    fid = fopen( 'Results.csv', 'w' );
    fprintf( fid, '%s,%s,%s,%s\n', "Osoba", "Ene", "Ene+ZCR", "Spectrum");
    for jj = 1 : n_persons
        fprintf( fid, '%s,%.2f,%.2f,%.2f\n', persons(jj), results_ene(jj), results_ene_zcr(jj), results_spectrum(jj));
    end
    fprintf( fid, '%s,%.2f,%.2f,%.2f\n', "PRUMER", mean(results_ene), mean(results_ene_zcr), mean(results_spectrum));
    fclose( fid );
end