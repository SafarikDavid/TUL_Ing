function [P, V, B] = ComputeViterbi(x, I, a_stay, a_move, const, means, vars, S)

V = zeros(I, S+1);
B = V;
B(1, 2) = 2;
V(1, :) = -Inf;
V(:, 1) = -Inf;
V(1, 2) = ComputeB(x(1), const(1), means(1), vars(1));

for i = 2:I
    for s = 1:S
        s_true = s + 1;
        if s-1 <= 0
            temp_move = a_move(end) + V(i-1, s_true-1);
        else
            temp_move = a_move(s-1) + V(i-1, s_true-1);
        end
        temp_stay = a_stay(s) + V(i-1, s_true);
        b = ComputeB(x(i), const(s), means(s), vars(s));
        V(i, s_true) = b + max(temp_move, temp_stay);
        if temp_move > temp_stay
            B(i, s_true) = s_true - 1;
        else
            B(i, s_true) = s_true;
        end
    end
end

P = V(end, end);

B = B(:, 2:end)-1;

f = zeros(1, size(B, 1));
f(I) = S;
for i = I-1:-1:1
    f(i) = B(i+1, f(i+1));
end

% heatmap(flip(V'))
% figure
% heatmap(flip(B'))

end

