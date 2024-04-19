close all
clear *

% importujte do Matlabu data foetalECG.mat pomoci prikazu load

% Zobrazte si signál foetal_ecg pomocí příkazu eegplot

% Pomocí adaptivního LMS algoritmu vypočtěte LMS filtr, který filtrováním 
% některého ze signálů měřených v hrudní oblasti dává signál co nejvíce 
% "podobný" některému ze signálů z abdominální oblasti. 

% Zfiltrovaný signál z hrudní oblasti výsledným filtrem odečtěte od 
% vybraného signálu z abdominální oblasti a výsledek zobrazte.

