clc; close all; clear all;

%% Load data
provided = load("word_features-ENE.mat");

numClasses = 10;

wordFeatures = provided.word_features.';
wordFrames = provided.word_frames.';
wordClass = provided.word_class;
trainSet = provided.train_set;
testSet = provided.test_set;

numStates = provided.num_HMM_states;
modelClass = provided.hmmClass;
modelMean = provided.hmmMeans;
modelVar = provided.hmmVars;
modelConst = provided.hmmConst;
modelTrans = provided.hmmTrans;

targetScores = reshape(provided.scores_to_check, numClasses, []);
targetAccuracy = provided.accuracy;

%% Classify
scores = zeros(size(targetScores));

for testSetI = 1 : length(testSet)
    wordI = testSet(testSetI);

    wordLen = wordFrames(wordI);
    features = wordFeatures(1 : wordLen, wordI);
    
    % b
    outputProbability = calcOutputProbability(features, modelMean, modelVar, modelConst);

    % V
    cumulative = -Inf(numClasses, numStates, wordLen);
    cumulative(:, 1, 1) = outputProbability(:, 1, 1);

    % B
    backtrack = zeros(numClasses, numStates, wordLen);

    for i = 2 : wordLen
        sStart = max(1, numStates - (wordLen - i));
        sStop = min(i, numStates);
        for s = sStart : sStop
            for c = 1 : numClasses
                scoreStay = cumulative(c, s, i - 1) + modelTrans(c, s, 1);

                if s - 1 > 0
                    scoreMove = cumulative(c, s - 1, i - 1) + modelTrans(c, s - 1, 2);
                else 
                    scoreMove = -inf;
                end

                if scoreStay >= scoreMove
                    backtrack(c, s, i) = s;
                    chosenScore = scoreStay;
                else
                    backtrack(c, s, i) = s - 1;
                    chosenScore = scoreMove;
                end
                cumulative(c, s, i) = chosenScore + outputProbability(c, s, i);
            end
        end
    end

    scores(:, testSetI) = cumulative(:, end, end);
end

[~, predictedIdx] = max(scores, [], 1);
classes = 0 : 9;
predicted = classes(predictedIdx);

accuracy = mean(predicted == wordClass(testSet)) * 100;

fprintf("Přesnost: %.02f %%\n", accuracy);
fprintf("Stejná jako vzorová: %s\n", string(accuracy == targetAccuracy));
fprintf("Stejné skóre jako vzorové: %s\n", string(all(scores == targetScores, 'all')));