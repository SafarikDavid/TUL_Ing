function [train_set, test_set, num_test, num_train] = makeTrainTestSetsSD(num_records, speaker_set, sp, train_set_limit)
train_set = [];
test_set = [];
for i = 0:5:num_records-5
    train_set = [train_set (1:train_set_limit)+i];
    test_set = [test_set (train_set_limit+1:5)+i];
end
num_test = length(test_set);
num_train = length(train_set);
end

