clear all; close all; clc;

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
% tic
% [dist_moje, A, B] = ComputeDTW (word_feat', word_num_frames, ref_feat', ref_num_frames, num_features);
% toc
% subplot(1, 2, 1)
% A(A == Inf) = 1e38;
% heatmap(flip(A(:, 3:end)'))
% subplot(1,2,2)
% heatmap(flip(acc_dist_matrix(:, 3:end)'))
% A - acc_dist_matrix
% B - double(back_matrix)


% polovina delky test - 1
% 2 x delka test
word_feat = ones(2, 49);
ref_feat = ones(2, 98);
[dist_moje, A, B] = ComputeDTW (word_feat, size(word_feat, 2), ref_feat, size(ref_feat, 2), size(ref_feat, 1));
dist_moje
figure
A(A == Inf) = 1e38;
heatmap(flip(A(:, 3:end)'))