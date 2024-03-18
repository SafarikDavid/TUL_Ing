% Úkol č. 1: Simulace komprimovaného vzorkování a rekonstrukce
% Vygenerujte řídký signál x délky 1000 s volitelným počtem nenulových koeficientů S (10 až 800). K signálu můžete případně přičíst i malé množství šumu, aby nebyl v pravém slova smyslu řídký.
% Vygenerujte náhodnou ortogonální matici U s pomocí příkazu orth.
% Pomocí U navzorkujte komprimovaný signál x do proměnné y.
% Rekonstruujte signál x z jeho komprimovaného záznamu y pomocí:
% metody Orthogonal Matching Pursuit (OMP.m) 
% pomocí metod z balíku l1-magic (https://github.com/scgt/l1magic)
clc; clear all; close all;
addpath l1magic-master\
addpath l1magic-master\Optimization\

N = 1000;
S = 20;
m = 300;
noise_mul = 0.;

x = zeros(N, 1);

non_zero_idxs = randperm(N);
non_zero_idxs = non_zero_idxs(1:S);

x(non_zero_idxs) = randn(S, 1);
x = x + randn(N, 1)*noise_mul;

% plot(x)

U = orth(randn(N));
U = U(:, 1:m);
y = U'*x;

% figure()
% plot(y)

x_hat = OMP(U', y, 20);
figure()
plot(x, 'b')
hold on
plot(x_hat, 'g')

% % % 
x2_hat = l1eq_pd(zeros(N, 1), U', [], y);
plot(x2_hat, 'r')