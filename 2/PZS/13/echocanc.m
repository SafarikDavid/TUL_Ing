clc; clear all; close all;

Nb = 2000;

[mx, mx_fs] = audioread('echo_mix.wav');
[fe, fe_fs] = audioread('echo_farend.wav');

A = toeplitz(fe, [fe(1) zeros(1, Nb-1)]);
ATA = A'*A;
Amx = A'*mx;
g = ATA\Amx;

plot(g)

y = mx - filter(g, 1, fe);