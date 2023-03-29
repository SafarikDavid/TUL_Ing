function [Mi,Mx] = FindMinMaxJ(i, I, J)
K = round((i + 1) / 2);
K1 = J - (I - i) * 2;
if K < K1
    K = K1;
end
Mi = K;
K = 2*i - 1;
K1 = round(J - (I - i) / 2);
if K > K1
    K = K1;
end
Mx = K;
end

