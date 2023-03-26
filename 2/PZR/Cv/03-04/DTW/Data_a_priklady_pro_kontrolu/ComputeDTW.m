function [res, A, B] = ComputeDTW(X,I,R,J,P)
    % Funkce vytvori transformacni cestu a vraci vzdalenost mezi ni a vstupem X
    % X - hledany signal, I - delka X
    % R - referencni signal, J - delka R
    % P - pocet priznaku

    %     prilis velky rozdil delek vraci Inf
    if (J == ceil(I/2)-1) || (J == 2*I)
        res = Inf;
        A = [];
        B = [];
        return
    end

    A = zeros(I, J+2);
%     flip(A')
    A(1, :) = Inf;
    A(:, 1:2) = Inf;
    A(1, 3) = ComputeEuclidDist(X(:, 1), R(:, 1), P);
    B = zeros(I, J+2);

    for i = 2:I
        for jj = 1:J
            j = jj+2;
            temp = zeros(1, J+2)+Inf;
            temp(1, j-2:j) = [A(i-1, j-2) A(i-1, j-1) A(i-1, j)];
            if B(i-1, j) == jj
                temp(j) = Inf;
            end
            A(i, j) = ComputeEuclidDist(X(:, i), R(:, jj), P) + min(temp);
%             flip(A(:, 3:end)')
            [~, B(i, j)] = min(temp);
            B(i, j) = abs(B(i, j) - 2);
%             flip(B(:, 3:end)')
        end
    end

    res = A(I, J+2);

    return

    w = zeros(I, 1);
    w(I) = J;

    B_cut = B(:, 3:end);

    for i = I-1:-1:1
        w(i) = B_cut(i+1, w(i+1));
    end

    Ydtw = R(:,w);

    subplot(4,1,1)
    plot(X)
    title("X")
    xlim([1 max(I, J)])
    subplot(4,1,2)
    plot(R)
    title("R")
    xlim([1 max(I, J)])
    subplot(4,1,3)
    plot(X)
    hold on
    plot(Ydtw)
    legend("X", "R")
    title("Diff")
    xlim([1 max(I, J)])
    subplot(4,1,4)
    plot(w)
    grid()
    yticks(1:J)
    xticks(1:I)
    title("Path")
end

