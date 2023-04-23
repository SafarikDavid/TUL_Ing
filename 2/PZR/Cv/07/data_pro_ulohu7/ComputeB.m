function b = ComputeB(x, const, mean, var)
b = const - ((x - mean)^2)/(2*var);
end

