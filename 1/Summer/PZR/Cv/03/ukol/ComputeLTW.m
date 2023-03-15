function res = ComputeLTW(X,I,R,J,P)
    % Funkce vytvori transformacni cestu a vraci vzdalenost mezi ni a vstupem X
    % X - hledany signal, I - delka X
    % R - referencni signal, J - delka R
    % P - pocet priznaku
    f = zeros(I,1);
    for i = 1:I
        f(i) = int32(fix(((J-1)/(I-1))*(i-1)+1+0.5));
    end
    Yltw = R(:,f);
    res = ComputeEuclidDist(X,Yltw,P);
end

