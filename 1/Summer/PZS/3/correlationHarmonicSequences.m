clear *;
close all;
clc;

n = 0:1000;
n2 = 10:1010;

x = sin(0.02*pi*n);
x2 = sin(0.02*pi*n2);   %Signal x2 is a shifted version of x by ten samples

plot(x);hold on;plot(x2);

c = xcorr(x,x2);
figure;plot(c);     %The center of correlation function, lag=0, is Matlab stored on index length(x), i.e., 1001
                    %The maximum of the correlation function is stored in Matlab index 1011
                    %This means that signal x2 preceeds signal x by 10 samples, as expected

x = x+0.5*randn(size(x));
x2 = x2+0.5*randn(size(x2));

figure;
c2 = xcorr(x,x2);        %If we add noise to the signal, the analysis is inaccurate, the maximum may shift away from the sample 1011 (lag=10)
plot(c2);