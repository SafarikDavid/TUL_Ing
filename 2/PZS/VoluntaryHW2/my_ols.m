function [y] = my_ols(x, h)
% vypocet delek
L = length(h);
overlap = L-1;
N = 2^nextpow2(2*L);
M = N-overlap;

% vypocet dft pro impulzni odezvu
H = fft(h, N);

% vytvoreni x_1 - pridani nul na zacatek o delce L-1
x_temp = [zeros(overlap, 1); x(1:M)];

y = [];
% vypocet kruhove konvoluce x_1 a h pomoci DFT
temp = ifft(fft(x_temp, N) .* H);

% pridani vypoctene konvoluce do vektoru vysledku
y = [y; temp(end-M+1:end)];

for i = M+1:M:length(x)
    % vyriznuti n-teho segmentu
    x_temp = x(i-overlap:min(i+M-1, length(x)));
    % vypocet kruhove konvoluce n-teho segmentu a h pomoci DFT
    temp = ifft(fft(x_temp, N) .* H);
    % pridani vysledku do vektoru vysledku
    y = [y; temp(end-M+1:end)];
end

end
