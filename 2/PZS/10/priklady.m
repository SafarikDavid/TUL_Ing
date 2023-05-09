clc; clear all; close all;

roots([4 -7/4 1/4])
roots([1 -3/4 1/8])

zplane([4 -7/4 1/4], [1 -3/4 1/8])

[z, p, k] = residuez([4 -7/4 1/4], [1 -3/4 1/8])

%% jednostranna Z-transformace
clc; clear all; close all;

[z, p, k] = residuez([1/8 1/8], [1 -3/4 1/8])

N = 20;
n = 0:N;

y = (3/4)*(1/2).^n-(5/8)*(1/4).^n;

b = [1];
a = [1 -3/4 1/8];
x = [1; zeros(N, 1)];

% pro matlab filter je potreba prepocitat pocatecni podminky
init_c = filtic(b, a, [-1 1]);
y2 = filter(b, a, x, init_c);  % v praxi je tohle jediny co potrebujes

stem(n, y); hold on; stem(n, y2);

chyba = sum((y-y2').^2)

%% inverzni system
clc; clear all; close all;
roots([1 -4 5])

figure;
zplane([1 -4 5], [1 -1 0.5])
figure;
freqz([1 -4 5], [1 -1 0.5])

% tohle je stabilni a kauzalni, ale nema inverzi

figure;
zplane([5 -4 1], [1 -1 0.5])
figure;
freqz([5 -4 1], [1 -1 0.5])

figure;
phasedelay([1 -4 5], [1 -1 0.5])
hold on
phasedelay([5 -4 1], [1 -1 0.5])