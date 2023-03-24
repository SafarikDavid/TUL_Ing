clc; clear all; close all;

Fs = 16000;

t = 0:Fs:3 - 1/Fs;

pomery = 2.^(0:1/12:1);
% kvinta je 3/2
% takze 1.5, tady to mame 1.4983
D = 440*2/3;
Dt = pomery(1)*D;
Dist = pomery(2)*D;
Et = pomery(3)*D;
Ft = pomery(4)*D;
Fist = pomery(5)*D;
Gt = pomery(6)*D;
Gist = pomery(7)*D;
At = pomery(8)*D;
Aist = pomery(9)*D;
Ht = pomery(10)*D;
Ct = pomery(11)*D;
Cist = pomery(12)*D;
D2t = D*2;

soundsc(sin(2*pi*Dt*t) + sin(2*pi*Ft*t) + sin(2*pi*At*t), Fs)