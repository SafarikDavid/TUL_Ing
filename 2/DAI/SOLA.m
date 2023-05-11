clc; clear all; close all;

% SOLA

alfa = 1.2;
% delka okna
L = 1024;
% posun pri segmentaci
Sa = 512;
% pousn pri systeze
Ss = floor(alfa*Sa);
% vyreseni nabehu a poklesu

[x, fs] = audioread('zpěv dívka.wav');

x = x(:,1);

segments = {};
seg_ixd = 1;
for i = 1:Sa:length(x)
    end_index = min(i+L-1, length(x));
    segments{seg_ixd} = x(i:end_index);
    seg_ixd = seg_ixd+1;
end

new_x = segments{1};
for i = 2:length(segments)
    segment = segments{i};
    start_index = ((i-1)*Ss)+1;
    end_index = start_index+length(segment)-1;
    new_x(end+1:end_index) = 0;

    new_x_segment = new_x(start_index:end_index);

    [cross_corr, lags] = xcorr(new_x_segment, segment, 'biased');
    [max_corr, max_corr_idx] = max(cross_corr);

    new_x_segment = new_x_segment.*cos(linspace(0, pi/2, length(segment)))';
    segment = segment.*sin(linspace(0, pi/2, length(segment)))';
    new_x(start_index:end_index) = new_x_segment + segment;
end
