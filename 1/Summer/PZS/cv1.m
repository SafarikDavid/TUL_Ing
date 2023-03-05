clear all;
close all;
clc;

a = eye(5,4)
b = zeros(4,2)
% uniform
c = rand(3,2)
d = ones(3,4)
% gauss
e = randn(4,4)
f = 2*rand(1)+2
% histogram
temp = randn(1000,1)
% histogram(temp)

temp = 1:1:10

temp(3)

a(:)

a = [1 2 3];
b = [4 5 6];

a .* b
a * b'

a ./ b
a / b

a + b'
a - b'

x = randn(3,10)
x_mean = mean(x,2)
x - x_mean

n = 0:100;
x = sin(pi/20*n);
figure;
plot(n,x)
stem(n,x) %lizatkovy graf

re = cos(pi/20*n);
im = sin(pi/20*n);

figure;
plot(re, im)