clc; clear all; close all;

[x, x_fs] = audioread("samba_short.wav");
x_len = length(x);

t = (0:x_len-1)/x_fs;
figure;
plot(t,x);

soundsc(x, x_fs)
clear sound

r_on = 5;
r_samp = r_on * x_fs;
r = ones(size(x));
r(1:r_samp+1) = 0:1/r_samp:1;
% r = [0:1/r_samp:1];

figure;
plot(t,r);

y = x.*r;
figure;
plot(t,y);

soundsc(y, x_fs);
clear sound
