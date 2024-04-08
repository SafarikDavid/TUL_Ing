% Rozklad matice na vlastní čísla a vektory
% Vygenerujte libovolnou symetrickou a pozitivně definitní matici
% Rozložte matici na vlastní čísla a vektory pomocí eig
% Ověřte rozklad a vlastnosti vlastních vektorů

clc; clear all; close all;

N = 10;

A = randn(N);
A = A + A';

[V, D] = eig(A);

V*V' % = eye(N)

V*D*V' % = A