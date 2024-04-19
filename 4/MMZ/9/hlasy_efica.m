clc; clear all; close all;

load('hlasy.mat')

A = randn(15);

X = A*S;

W = efica(X);

Y = W*X;

% zpatky jsou serazeny nahodne

imagesc(W*A) % radek je signal ted, sloupec je signal predtim

% permutacni matice je jednotkova s prehazenymi radky
% diagonalni nahodna cisla na diagonale

%% nefunguje pro gaussovske signaly
S(14, :) = randn(1, 134608);
S(15, :) = randn(1, 134608);
X = A*S;
W = efica(X);
imagesc(W*A)