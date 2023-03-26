function res = ComputeEuclidDist(X,R,P)
% x - signal
% R - reference
% P - pocet priznaku
    if (P == 1)
        res = sum(abs(X - R));
        return
    end
    suma = sum(sum((X-R).^2, 2));
    res = sqrt(suma);
end

