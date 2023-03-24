clear all;

%save ('DTW-example1.mat', 'num_features', 'word_num_frames', 'ref_num_frames','word_feat', 'ref_feat', 'acc_dist_matrix', 'back_matrix', 'dist', 'path')
load ('DTW-example2.mat');

% Vstupni promenne do funkce computeDTW
% word_feat - priznakove vektory slova .. matice (word_num_frames, num_features)
% ref_feat - priznakove vektory reference .. matice (ref_num_frames, num_features)

% Vystupni promenna z funkce computeDTW
% Vzdalenost spocitana na zaklade DTW s Itakurovymi podminkami

% Hodnoty pro kontrolu
% na konci sveho vypoctu jsem nechal ulozit do souboru MAT
% obsah matice A  - u mne pojmenovane acc_dist_matrix o velikosti word_num_frames, ref_num_frames+2)
% obsah matice B  - u mne pojmenovane back_matri o velikosti word_num_frames, ref_num_frames+2)
% dist - hodnota, ktera mi vysla
% path - nejlepsi cesta, ktera mi vysla


% zde je priklad jak svou funkci volam
[dist_moje, A, B] = ComputeDTW (word_feat', word_num_frames, ref_feat', ref_num_frames, num_features);

% A - acc_dist_matrix
% B - double(back_matrix)