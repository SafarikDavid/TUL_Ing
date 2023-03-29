function res = ComputeDTW(X,I,R,J,P)
    % Funkce vytvori transformacni cestu a vraci vzdalenost mezi ni a vstupem X
    % X - hledany signal, I - delka X
    % R - referencni signal, J - delka R
    % P - pocet priznaku

%     prilis velky rozdil delek vraci Inf
    if (I > 2 * J) || (J > 2 * I - 1)
        res = Inf;
        return
    end
    accDist = ones(1, J+2) * Inf;
    wasHorizontal = zeros(1, J+2);
    accDist(3) = ComputeEuclidDist(X(:, 1), R(:, 1), P);
    for i = 2:I
        [Mi, Mx] = FindMinMaxJ(i, I, J);
        for j = Mx:-1:Mi
            jj = j + 2;
            temp = accDist(jj - 2);
            if temp > accDist(jj - 1)
                temp = accDist(jj - 1);
            end
            if wasHorizontal(jj) == 0 && accDist(jj) < temp
                wasHorizontal(jj) = 1;
                temp = accDist(jj);
            else
                wasHorizontal(jj) = 0;
            end
            accDist(jj) = temp + ComputeEuclidDist(X(:, i), R(:, j), P);
        end
        accDist(Mi + 2 - 1) = Inf;
    end
    res = accDist(end);
end

