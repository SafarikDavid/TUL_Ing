% Multi-channel LMS filtr
% Nahrajte si do Matlabu data ze souboru multichannel.mat. Signály s a v obsahují stereofonní záznamy signálů z reproduktorů, které byly umístěny v různých pozicích.
% 
% Nejprve spočítejte LMS filtr, který se snaží ze signálu x(:,1) vyfiltrovat signál s(:,1) a potom z celého x získat s(:,1). Pro výpočet filtrů použijte jen počáteční 3 vteřiny signálů, aby bylo zřejmé, na kterých usecích signálu spočtený filtr funguje.
clc; clear all; close all;

load("multichannel.mat")

h = miso_firwiener(1000, x(:, 1), s(:, 1));
y = filter(h, 1, x(:, 1));
% moc to nejde, protoze se prekryvaj frekvence obou mluvcich

h = miso_firwiener(1000, x, s(:, 1));
y2 = filter(h(1:end/2), 1, x(:, 1)) + filter(h(end/2+1:end), 1, x(:, 2));