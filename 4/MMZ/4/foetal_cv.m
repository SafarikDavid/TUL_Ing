clc; clear all; close all;

load("foetalECG.mat")
% eegplot(foetal_ecg')

% chest = mother
x = foetal_ecg(:, 7);
% abdominal = foetal + mother
d = foetal_ecg(:, 2);

N = length(d);
L = 10;
mu = 0.000001;
w = zeros(L,1);
y = zeros(N,1);
e_sig = zeros(N,1);

for n = L:N
    xn = x(n:-1:n-L+1);
    y(n) = w'*xn;
    e = d(n) - y(n);
    w = w + mu*xn*e;

    e_sig(n) = e;
    
    if mod(n,L)==0
        subplot(1,2,1)
        plot(w)
        axis([1 L -1 1])
        subplot(1,2,2)
        plot(1:N,d,'k',1:N,y,'r')
        axis([1 N -100 100])
        drawnow
    end
end

subplot(3,1,1)
plot(1:N, x)
title("Chest")
subplot(3,1,2)
plot(1:N, d)
title("Abdominal")
subplot(3,1,3)
plot(1:N, e_sig)
title("Child")