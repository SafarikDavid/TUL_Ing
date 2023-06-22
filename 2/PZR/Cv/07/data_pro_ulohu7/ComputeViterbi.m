function [P, V, B] = ComputeViterbi(x, I, a_stay, a_move, const, means, vars, S)

V = zeros(I, S);
B = V;
B(1, 1) = 1;
V(1, :) = -Inf;
V(1, 1) = ComputeB(x(1), const(1), means(1), vars(1));

for i = 2:I
    for s = 1:S
        if s-1 > 0
            temp_move = a_move(s-1) + V(i-1, s-1);
        else
            temp_move = -Inf;
        end
        temp_stay = a_stay(s) + V(i-1, s);
        b = ComputeB(x(i), const(s), means(s), vars(s));
        V(i, s) = b + max(temp_move, temp_stay);
        if temp_move > temp_stay
            B(i, s) = s - 1;
        else
            B(i, s) = s;
        end
    end
end

P = V(end, end);

f = zeros(1, size(B, 1));
f(I) = S;
for i = I-1:-1:1
    f(i) = B(i, f(i+1));
end

end
