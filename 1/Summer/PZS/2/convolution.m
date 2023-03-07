clc; clear all; close all;

conv([2 1 0 1 3], [0 1 1 1])

dp = load("DP.mat"); hp = load("HP.mat");
[x, x_fs] = audioread("samba_short.wav");

y = conv(x, dp.b_dp);
y = conv(x, hp.b_hp);

soundsc(y, x_fs)
clear sound

% filter dela to samy, ale pomoci koeficientu diferencni rovnice
% tady to jde, protoze koeficienty nerekurzivni rovnice jsou koef imp
% odezvy

y = filter(dp.b_dp, 1, x);
soundsc(y, x_fs)
clear sound