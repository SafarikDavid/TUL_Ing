function [y] = my_ola(x, h)
L = length(h);
N = length(x);
% Nb = block length
Nb = 2^nextpow2(2*L);
% M + L - 1 = Nb
M = Nb - L + 1;
bl_num = ceil(N / M);

h_bl = zeros(Nb, 1);
h_bl(1:L) = h;
H_bl = fft(h_bl);

y = zeros(N+L-1, 1);

for lp = 1:bl_num
    start = (lp - 1)*M+1;
    stop = min(lp*M, N);
    
    M_true = stop - start + 1;

    x_bl = zeros(Nb, 1);
    x_bl(1:M_true) = x(start:stop);

    y_bl = ifft(fft(x_bl) .* H_bl);

    y_ln_true = M_true+L-1;

    Nb_true = M_true+L-1;

    y(start:start+Nb_true-1) = y_bl(1:Nb_true) + y(start:start+Nb_true-1);
end
end
