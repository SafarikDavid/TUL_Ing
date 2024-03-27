% Charakteristika Delay-and-sum beamformeru
% Vizualizujte charakteristickou funkci delay-and-sum beamformeru za předpokladu, že
% 
%   zvuk se šíří ideálním prostředím bez odrazů rychlostí 330 m/s, 
%   zvuk se šíří pouze v rovině xy (tedy v podstatě ve 2D) a
%   tři mikrofony jsou rozmístěny lineárně podél osy x a jsou vzájemně vzdálené 10 cm.
% Charakteristickou funkci zobrazte jako polární graf pro zvolenou frekvenci a zvolená zpozdění beamformeru.

clc; clear all; close all;

c = 320;
d = 0.1; % vzájemná vzdálenost mikrofonů v metrech
fs = 16000;

% xyz coordinates
p = [[-0.2; 0; 0], [-0.1; 0; 0], [0; 0; 0], [0.1; 0; 0], [0.2; 0; 0]]; % vzd pro kazdy mikrofon
N = size(p, 2); % Počet mikrofonů

% Frekvence
f = 1000;

elevation_steering = pi/2;
azimuth_steering = pi/2;
u = -[sin(elevation_steering)*cos(azimuth_steering); sin(elevation_steering)*sin(azimuth_steering); cos(elevation_steering)];
D = u'*p*fs/c;

elevation = pi/2;
angle_values = 0:0.01:2*pi;
Psi = zeros(1, length(angle_values));
for i = 1:length(angle_values)
    azimuth = angle_values(i);
    u = -[sin(elevation)*cos(azimuth); sin(elevation)*sin(azimuth); cos(elevation)];
    M = u'*p*fs/c;
    Psi(i) = sum(exp(-1i*2*pi*f/fs*(D-M)))/N;
end


% Vykreslení polárního grafu
figure;
polarplot(angle_values, abs(Psi));
