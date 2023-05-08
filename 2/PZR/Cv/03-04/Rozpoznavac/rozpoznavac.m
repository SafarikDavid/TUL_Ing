clc; clear all; close all;

global num_HMM_states
global hmmTrans
global hmmMeans
global hmmVars
global hmmConst
global hmmClass

% ↓---------------------------nastaveni----------------------------------↓

num_classes = 10;
max_iter = 8;
num_HMM_states = 10;
max_frames = 201;

% nacteni cest pro nahravky
file_list = readlines("FileListSI.txt", "EmptyLineRule", "skip");
n_recordings = length(file_list);

% select if speaker dependent
speaker_dependent = false;

% coefficient selection
% 1 - ene
% 2 - ene + zcr
% 3 - spectrum
% 4 - fbank
% 5 - MFCC
% 6 - MFCC + Delta
coefficient_select = [5, 6];

% distance method select
% 1 - LTW
% 2 - DTW
% 3 - HMM
distance_method = 3;

% select train and test sets
train_sets = '[1-5]'; %SI
% train_sets = '[1-3]'; %SD
test_sets = '[4-5]';

% plot signal settings
% sound_cutout will be reached only if plot_data is true
plot_data = false;
play_cutout = true;

% nastaveni vypisu do konzole
write_results_to_console = true;
write_suspicious_data_to_console = false;

% export settings
export_to_csv = false;
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
bound_threshold_percentage = 0.4; %0.4/0.35 best
boundary_shift = 20;

% nastaveni segmentace
segment_len = 400;
frame_overlap = 160;

% ↑---------------------------nastaveni----------------------------------↑
% vypis zacatku pocitani koeficientu
fprintf("Starting coefficient calculation\n");

tic

test_indexes = [];
train_indexes = [];
persons_train = [];
persons_test = [];
persons_unique = [];
word_class = zeros(1, n_recordings);

for i = 1:n_recordings
    class = file_list(i);
    class = convertStringsToChars(class);
    word_class(i) = str2num(class(end-14));
%     rozdeleni nahravek na trenovaci sadu a testovaci sadu
    if(speaker_dependent)
        %     nacteni cisla osoby
        person = file_list(i);
        person = convertStringsToChars(person);
        person = convertCharsToStrings(person(end-12:end-8));
        persons_unique = unique([persons_unique person]);
        if(regexp(file_list(i), strcat(['s0', train_sets, '.wav'])))
            persons_train = [persons_train person];
            train_indexes = [train_indexes i];
        end
        if(regexp(file_list(i), strcat(['s0', test_sets, '.wav'])))
            persons_test = [persons_test person];
            test_indexes = [test_indexes i];
        end
    else
        %     nacteni cisla osoby
        person = file_list(i);
        person = convertStringsToChars(person);
        person = convertCharsToStrings(person(end-12:end-8));
        if(regexp(file_list(i), strcat(['p00[0-9][0-9]_s0', train_sets, '.wav'])))
            persons_train = [persons_train person];
            train_indexes = [train_indexes i];
        end
        if(regexp(file_list(i), strcat(['p[1-9][1-9][0-9][0-9]_s0', test_sets, '.wav'])))
            persons_test = [persons_test person];
            test_indexes = [test_indexes i];
            % ulozeni unikatni testovane osoby
            persons_unique = unique([persons_unique person]);
        end
    end
end
for i = 1:n_recordings
    [x, Fs] = audioread(file_list(i), "native");
    x = x(1:32000);
    x_len = length(x);

%     add noise
    x = x + (randi(3, 32000, 1, 'int16') -2);
%     filter
    x = filter([1 -0.97], 1, x);

    [frames, energy] = ComputeFramesAndEnergy(x, segment_len, frame_overlap);

    [word_start, word_end, word_threshold] = FindWordBoundary(energy, bound_k_extremas, bound_threshold_percentage, boundary_shift);

    cutout = x(frame_overlap*(word_start-1)+1:frame_overlap*word_end);
    cutout_frames = frames(:, word_start:word_end);
    cutout_energy = energy(word_start:word_end);

%     uložení energie
    if ismember(1, coefficient_select)
        energy_coeff{i} = cutout_energy;
    end
%     uložení ene+zcr
    if ismember(2, coefficient_select)
        %     normalizace energie + zcr
        zcr = ComputeZCR(cutout_frames);
        energy_and_zcr_coeff{i} = [(cutout_energy-mean(cutout_energy))./max(cutout_energy); (zcr-mean(zcr))./max(zcr)];
    end
%     uložení spektrálních příznaků
    if ismember(3, coefficient_select)
        spectrum = ComputeSpectrum(cutout_frames, window_length, K_value);
        spectral_coeff{i} = spectrum;
    end
    if ismember(4, coefficient_select) || ismember(5, coefficient_select) || ismember(6, coefficient_select)
        [cepstrum, mel_fbank] = ComputeFramesMFCC(cutout_frames, 26, 12, Fs);
        if ismember(-Inf, cepstrum) || ismember(Inf, cepstrum)
            cepstrum(cepstrum <= -Inf) = 0;
            cepstrum(cepstrum >= Inf) = 0;
        end
        fbank_coeff{i} = mel_fbank;
        cepstrum_coeff{i} = cepstrum;
        cepstrum_delta_coeff{i} = [cepstrum; ComputeDeltaCoeff(cepstrum)];
    end
    
%     kontrola délky výstřižků
    if (abs(word_end - word_start) > 100) && write_suspicious_data_to_console
        fprintf("Extreme boundary diff found %d: %s\n", abs(word_end - word_start), file_list(i))
    end

%     zobrazení jednotlivých slov
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
toc

% vypis, ze je hotovy vypocet koeficientu
fprintf("Done Calculating Coefficients\n");

n_persons = length(persons_unique);

len_test = length(test_indexes);

% prealokace poli pro vysledky
results_spectrum = zeros(1, n_persons);
results_ene_zcr = zeros(1, n_persons);
results_ene = zeros(1, n_persons);
results_fbank = zeros(1, n_persons);
results_cepstrum = zeros(1, n_persons);
results_cepstrum_delta = zeros(1, n_persons);

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
            coeff_name = "Spectral";
        case 4
            coeff = fbank_coeff;
            coeff_name = "fbank";
        case 5
            coeff = cepstrum_coeff;
            coeff_name = "MFCC";
        case 6
            coeff = cepstrum_delta_coeff;
            coeff_name = "MFCC_Delta";
    end

    % priprava hmm modelu
    num_features = size(coeff{1}, 1);
    hmmTrans = zeros (num_classes, num_HMM_states, 2);
    hmmMeans = zeros (num_classes, num_HMM_states, num_features);
    hmmVars = zeros (num_classes, num_HMM_states, num_features);
    hmmConst = zeros (num_classes, num_HMM_states);
    hmmClass = [0:num_classes-1];
    
%     vypis rozpoznavanych priznaku do konzole
    if write_results_to_console
        fprintf("\nCurrent coefficient set: %s\n", coeff_name)
    end
    
    tic

    if distance_method == 3 && speaker_dependent == false
        train_set = train_indexes;
        disp("Now training");
        for c = 1:num_classes
            ret =  trainHMM (c, train_set, coeff, num_features, word_class, max_iter, max_frames);
        end
        disp("Done training");
    end

    last_person = '';
    predictions = zeros(len_test, 1);
    ground_truth = zeros(len_test, 1);
    for i = 1:len_test
        person_id = persons_test(i);
        if (speaker_dependent)
            person_train_idxs = train_indexes(persons_train == person_id);
            if distance_method == 3 && ~strcmp(person_id, last_person)
                last_person = person_id;
                train_set = person_train_idxs;
                disp("Now training");
                for c = 1:num_classes
                    ret =  trainHMM (c, train_set, coeff, num_features, word_class, max_iter, max_frames);
                end
                disp("Done training");
            end
        else
            person_train_idxs = train_indexes;
        end

        test_index = test_indexes(i);
        test_coeff = coeff{test_index};
        
        % select ground truth
        ground_truth(i) = word_class(test_index);
        
        score = zeros(1, num_classes);
        if distance_method == 3
            for model_id = 1:num_classes
                scr = computeHMMViterbi_fast (test_coeff', size(test_coeff, 2), model_id); % vypocet skore kazdeho modelu
                score (model_id) = scr; % ulozeni skore do pole pro nalezeni maxima
            end
            [max_score, best] = max(score);
            predictions(i) = hmmClass(best);
            fprintf("Pred: %d, Truth: %d\n", hmmClass(best), word_class(test_index))
            continue
        end

        P = size(test_coeff, 1);
        I = size(test_coeff, 2);
        distances = zeros(size(person_train_idxs));
        for j = 1:length(person_train_idxs)
            train_index = person_train_idxs(j);
            train_coeff = coeff{train_index};
            J = size(train_coeff, 2);
            switch distance_method
                case 1
                    distances(j) = ComputeLTW(test_coeff, I, train_coeff, J, P);
                case 2
                    distances(j) = ComputeDTW(test_coeff, I, train_coeff, J, P);
            end
        end
        [best_dist, best_dist_idx] = min(distances);

        % select word prediction
        prediction_idx = train_indexes(best_dist_idx);
        predictions(i) = word_class(prediction_idx);
        fprintf("Pred: %d, Truth: %d\n", word_class(prediction_idx), word_class(test_index))
    end

    toc

    for i = 1:n_persons
        person_unique = persons_unique(i);
        predictions_unique = predictions(persons_test == person_unique);
        ground_truth_unique = ground_truth(persons_test == person_unique);
        acc_unique = sum(predictions_unique == ground_truth_unique)/length(predictions_unique) * 100;
            
        if write_results_to_console
            fprintf("Person: %s, Acc: %.2f\n", person_unique, acc_unique)
        end

        switch select
            case 1
                results_ene(i) = acc_unique;
            case 2
                results_ene_zcr(i) = acc_unique;
            case 3
                results_spectrum(i) = acc_unique;
            case 4
                results_fbank(i) = acc_unique;
            case 5
                results_cepstrum(i) = acc_unique;
            case 6
                results_cepstrum_delta(i) = acc_unique;
        end
    end
end


% vypis prumeru do konzole
if write_results_to_console
    fprintf("-----------------------------------------\n")
    fprintf('MEAN: ene: %.2f, ene+zcr:%.2f, spectrum:%.2f, fbank:%.2f, mfcc:%.2f, mfcc24:%.2f\n', ...
        mean(results_ene), ...
        mean(results_ene_zcr), ...
        mean(results_spectrum), ...
        mean(results_fbank), ...
        mean(results_cepstrum), ...
        mean(results_cepstrum_delta));
    fprintf("-----------------------------------------\n")
end

% ulozeni do .mat souboru
if (export_to_mat == true)
    save('results.mat', "persons_unique", "results_spectrum", "results_ene_zcr", "results_ene", "results_fbank", "results_cepstrum", "results_cepstrum_delta")
end

% export do csv souboru
if (export_to_csv == true)
    fid = fopen( 'Results.csv', 'w' );
    fprintf( fid, '%s,%s,%s,%s,%s,%s,%s\n', "Osoba", "Ene", "Ene+ZCR", "spec16", "fbank26", "mfcc12", "mfcc24");
    for jj = 1 : n_persons
        fprintf( fid, '%s,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n', ...
            persons_unique(jj), ...
            results_ene(jj), ...
            results_ene_zcr(jj), ...
            results_spectrum(jj), ...
            results_fbank(jj), ...
            results_cepstrum(jj), ...
            results_cepstrum_delta(jj));
    end
    fprintf( fid, '%s,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n', "PRUMER", ...
        mean(results_ene), ...
        mean(results_ene_zcr), ...
        mean(results_spectrum), ...
        mean(results_fbank), ...
        mean(results_cepstrum), ...
        mean(results_cepstrum_delta));
    fclose( fid );
end

if beep_at_end
    beep
end