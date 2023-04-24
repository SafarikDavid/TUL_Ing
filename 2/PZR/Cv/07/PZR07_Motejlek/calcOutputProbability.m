function out = calcOutputProbability(x, mean, var, const)
    arguments
        x (1, 1, :)
        mean (:, :)
        var (:, :)
        const (:, :)
    end
    % mean, var, const: model x state

    out = const - ((x - mean) .^ 2) ./ (2 * var);
end