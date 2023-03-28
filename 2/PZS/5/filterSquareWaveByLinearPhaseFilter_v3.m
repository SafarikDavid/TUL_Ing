close all
clear all
clc

%Filtration of a square wave with low-pass filters with linear and non-linear phase
%Task: see Topic 4: Basic exercises

%%
%Generation of the square wave, the highest frequency is 9*0.02*pi, which is less
%than cutt-off frequency of the considered filters (0.2*pi)
%The whole specturm of the square wave thus lies in the p[ass band of the filter 
% and the filtration (almost) should not change the signal (up to a delay)
wb = 0.02.*pi;
n=0:999;
K=2;
x = zeros(size(n));
for lpW = 1:K
   x = x + (4/pi)*sin((2*lpW-1)*wb.*n)/(2*lpW-1);
end
%Active frequencies
ws = (1:2:(2*K-1))*wb;

%computation and visualization of the DTFT spectrum (we have finite and short signal, the spectrum is only approximately sparse)
[X,w]=dtft(x,10*length(x),true);
figure;plot(w/pi,abs(X));

%Loads filter with linear phase
load('filter_1.mat');

%Visualization of the magnitude characteristic and the phase delay
[h,w] = freqz(B,A,1024);
figure;plot(w/pi,abs(h));
figure;phasedelay(B,A,1024);

%Filtration
y1=filter(B,A,x);

%Shows magnitude and phase delays for all active frequencies in 'x' (for linear phase filter: phase delays are the same for all frequencies )
[hp1,wp1]=freqz(B,A,ws);
disp('Magnitude:');
abs(hp1)
disp('Delay:')
[dp1,wp1]=phasedelay(B,A,ws);
dp1
wp1/pi

%Average delay of the active frequency components (equals delay of each component)
dt=round(mean(dp1));

%Visualization (compensation of the average phase delay in y1)
%The input 'x' and the output y1 are approximately the same, as expected
%(Up to the start of the signal, which is a transient phenomenon, in other words, the filter does not have all required samples at the beginning of the signal)
figure;
plot(n(1:200),x(1:200),'b',n(1:200),y1(1+dt:200+dt),'r');
legend('Original','Filtered');

%%
%The same steps for a filter with a nonlinear phase (IIR low-pass)
load('filter_2','BB','AA');

[hh,ww] = freqz(BB,AA,1024);
figure;plot(ww/pi,abs(hh));
figure;phasedelay(BB,AA,1024);

y2=filter(BB,AA,x);

[hp2,wp2]=freqz(BB,AA,ws);
disp('Magnitude:');
abs(hp2)
disp('Delay:')
[dp2,wp2]=phasedelay(BB,AA,ws);
dp2
wp2/pi

%Average delay of the active frequency components (each component is shifted by a differenct amount)
%There exist no single delay in time-domain, which would compensate the phase delay simultaneously for all frequency component
%This means that the shape of the output is changed after the filtration (phase distortion), although the magnitude spectrum of the signal is unchanged
dtt=round(mean(dp2));

figure;
plot(n(1:200),x(1:200),'b',n(1:200),y2(1+dtt:200+dtt),'r');
legend('Original','Filtered');