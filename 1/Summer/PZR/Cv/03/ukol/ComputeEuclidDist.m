function res = ComputeEuclidDist(X,R,P)
% x - signal
% R - reference
% P - pocet priznaku
    if (P == 1)
        res = sum(abs(X - R));
        return
    end
    suma = 0;
    for i = 1:P
        suma = suma + sum((X(i,:) - R(i,:)).^2);
    end
    res = sqrt(suma);
end

