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

%     subplot(4,1,1)
%     plot(X)
%     title("X")
%     xlim([1 max(I, J)])
%     subplot(4,1,2)
%     plot(R)
%     title("R")
%     xlim([1 max(I, J)])
%     subplot(4,1,3)
%     plot(X)
%     hold on
%     plot(Yltw)
%     legend("X", "R")
%     title("Diff")
%     xlim([1 max(I, J)])
%     subplot(4,1,4)
%     plot(f)
%     grid()
%     yticks(1:J)
%     xticks(1:I)
%     title("Path")
end

