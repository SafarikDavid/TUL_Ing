clc; clear all; close all;

% 500 a 510 razy
% 2000 a 2020 nejsou razy
fs = 16000;
f1 = 2000;
f2 = 2020;
len = 5;
n = 0:1/fs:len-1/fs;
sig1 = sin(2*pi*f1*n);
sig2 = sin(2*pi*f2*n);

% vzdycky razy
sig = sig1+sig2;

% nad 1500? nejsou razy - sluchatka
sig = [sig1; sig2];

soundsc(sig, fs)