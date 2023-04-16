function out = ComputeDeltaCoeff(coefficients)
out = zeros(size(coefficients));
out(:, 1) = coefficients(:, 2) - coefficients(:, 1);
out(:, end) = coefficients(:, end) - coefficients(:, end-1);
out(:, 2:end-1) = coefficients(:, 3:end) - coefficients(:, 1:end-2);
end

