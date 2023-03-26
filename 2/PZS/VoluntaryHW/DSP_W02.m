clc; clear all; close all;

plot_power = true;

% read signal from wav
[x, fs] = audioread("MyVowels.wav");
t = 0:1/fs:length(x)/fs - 1/fs;

% magnitude shift substraction
x_m = x - mean(x);

% instantaneous power computation
x_p = x_m.^2;

% Moving average filter application
% N - length of filter
N = 1000;
B = ones(1,N)./N;
A = 1;
x_p = filter(B, A, x_p);

% search for speech threshold
k = 10000;
t_ratio = 0.05;
mean_maxk = mean(maxk(x_p, k));
mean_mink = mean(mink(x_p, k));
threshold = mean_mink + t_ratio*(mean_maxk - mean_mink);

% plot power
if plot_power
    figure
    plot(t, x_p)
end

% selection of active speech samples
x_active = zeros(size(x));
x_active(x_p >= threshold) = max(x_m);
% x_active = filter(ones(1, 1000)/1000, 1, x_active);
% x_active(x_active > 0) = max(x_m);

% plot signal and active speech segments
figure
plot(t, x_m)
hold on
plot(t, x_active)
legend('Speech', 'VAD')
xlabel('t[s]')
ylabel('x[n][-]')