clc; clear all; close all;

Nb = 100; % do 25 je to vlastne jedno, kdyz odstranim hlavni peak, tak uz to nebude fungovat

[x, x_fs] = audioread("mix_speech_2ch.wav");

% jedna sekunda
xLp = x(1:1*x_fs,1);
xRp = x(1:1*x_fs,2);

A = toeplitz(xLp, [xLp(1), zeros(1, Nb-1)]);
ATA = A'*A;
AxR = A'*xRp;
g = ATA\AxR; %inv(ATA)*AxR

% delta funkce, takze minus
y = filter(g, 1, x(:,1)) - x(:,2);

stem(g)