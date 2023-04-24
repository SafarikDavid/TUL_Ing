clear all; close all;

load ('word_features-ENE.mat', 'word_features', 'word_frames', 'word_class', 'train_set', 'test_set', 'num_HMM_states', 'hmmTrans','hmmMeans', 'hmmVars', 'hmmConst','hmmClass','scores_to_check', 'accuracy');

hits = 0;
predictions = zeros(length(test_set), 1);
for i = 1:length(test_set)
    x_idx = test_set(i);
    x = word_features(x_idx, 1:word_frames(x_idx));
    max_idx = 0;
    max_val = -Inf;
    for j = 1:length(hmmClass)
        P = ComputeViterbi(x, length(x), hmmTrans(j, :, 1), hmmTrans(j, :, 2), hmmConst(j, :), hmmMeans(j, :), hmmVars(j, :), num_HMM_states);
        if P > max_val
            max_idx = j;
            max_val = P;
        end
    end
    predictions(i) = hmmClass(max_idx);
    if hmmClass(max_idx) == word_class(x_idx)
        hits = hits+1;
    end
end

fprintf("Acc: %.2f\n", hits/length(test_set)*100)