clc; clear all; close all;

% ↓---------------------------nastaveni----------------------------------↓

% nacteni cest pro nahravky
file_list = readlines("FileList.txt", "EmptyLineRule", "skip");
n_recordings = length(file_list);

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
write_results_to_console = true;
write_suspicious_data_to_console = false;

% export settings
export_to_csv = true;
export_to_mat = false;

% beep at end of script
beep_at_end = false;

% spectrum settings
window_length = 512;
K_value = 16;

% seed setting
rng(42);

% word boundary search settings
bound_k_extremas = 10;
bound_threshold_percentage = 0.4; %0.4/0.5 best

% nastaveni segmentace
pocet_vzorku_v_segmentu = 400;
frame_len = 160;

% ↑---------------------------nastaveni----------------------------------↑

test_indexes = [];
train_indexes = [];
persons_train = [];
persons_test = [];
persons_unique = [];

for i = 1:n_recordings
%     nacteni cisla osoby
    person = file_list(i);
    person = convertStringsToChars(person);
    person = convertCharsToStrings(person(end-12:end-8));
    persons_unique = unique([persons_unique person]);

%     rozdeleni nahravek na trenovaci sadu a testovaci sadu
    if(contains(file_list(i), 's01.wav'))
        persons_train = [persons_train person];
        train_indexes = [train_indexes i];
    else
        persons_test = [persons_test person];
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
    energy_and_zcr_coeff{i} = [(cutout_energy-mean(cutout_energy))./max(cutout_energy); (zcr-mean(zcr))./max(zcr)];
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

n_persons = length(persons_unique);

len_test = length(test_indexes);

% prealokace poli pro vysledky
results_spectrum = zeros(1, n_persons);
results_ene_zcr = zeros(1, n_persons);
results_ene = zeros(1, n_persons);

for coeff_sel_idx = 1:length(coefficient_select)
    select = coefficient_select(coeff_sel_idx);
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
    
    predictions = zeros(len_test, 1);
    ground_truth = zeros(len_test, 1);
    for i = 1:len_test
        test_index = test_indexes(i);
        test_coeff = coeff{test_index};
    
        truth = file_list(test_index);
        truth = convertStringsToChars(truth);
        ground_truth(i) = str2num(truth(end-14));
    
        P = size(test_coeff, 1);
        I = size(test_coeff, 2);
        min_dist_idx = 1;
        min_dist = 1e100;
        for j = 1:length(train_indexes)
            train_index = train_indexes(j);
            train_coeff = coeff{train_index};
            J = size(train_coeff, 2);
            dist = ComputeLTW(test_coeff, I, train_coeff, J, P);
            if (dist < min_dist)
                min_dist = dist;
                min_dist_idx = j;
            end
        end
    
        prediction_idx = train_indexes(min_dist_idx);
        prediction = file_list(prediction_idx);
        prediction = convertStringsToChars(prediction);
        predictions(i) = str2num(prediction(end-14));
    end
    
    acc_all = sum(predictions == ground_truth)/length(predictions) * 100;
    switch select
        case 1
            result_ene_all = acc_all;
        case 2
            result_ene_zcr_all = acc_all;
        case 3
            result_spectrum_all = acc_all;
    end

    for i = 1:n_persons
        person_unique = persons_unique(i);
        predictions_unique = predictions(persons_test == person_unique);
        ground_truth_unique = ground_truth(persons_test == person_unique);
        acc_unique = sum(predictions_unique == ground_truth_unique)/length(predictions_unique) * 100;
            
        if write_results_to_console
            fprintf("Person: %s, Coeff: %s, Accurracy: %.2f\n", person_unique, coeff_name, acc_unique)
        end

        switch select
            case 1
                results_ene(i) = acc_unique;
            case 2
                results_ene_zcr(i) = acc_unique;
            case 3
                results_spectrum(i) = acc_unique;
        end
    end
end

% vypis prumeru do konzole
if write_results_to_console
    fprintf("-----------------------------------------\n")
    fprintf('MEAN: ene: %.2f, ene+zcr:%.2f, spectrum:%.2f\n', result_ene_all, result_ene_zcr_all, result_spectrum_all);
    fprintf("-----------------------------------------\n")
end

% ulozeni do .mat souboru
if (export_to_mat == true)
    save('results.mat', "persons_unique", "results_spectrum", "results_ene_zcr", "results_ene")
end

% export do csv souboru
if (export_to_csv == true)
    fid = fopen( 'Results.csv', 'w' );
    fprintf( fid, '%s,%s,%s,%s\n', "Osoba", "Ene", "Ene+ZCR", "Spectrum");
    for jj = 1 : n_persons
        fprintf( fid, '%s,%.2f,%.2f,%.2f\n', persons_unique(jj), results_ene(jj), results_ene_zcr(jj), results_spectrum(jj));
    end
    fprintf( fid, '%s,%.2f,%.2f,%.2f\n', "PRUMER", result_ene_all, result_ene_zcr_all, result_spectrum_all);
    fclose( fid );
end

if beep_at_end
    beep
end