function [ trainf, trainl, testf, testl ] = Split( training_set, label_is_first )
  data_size = size(training_set, 1);
  feature_size = size(training_set, 2);
  test_size = int32(data_size * 0.1);
  train_size = data_size - test_size;
  if label_is_first
    trainf = [training_set(1:train_size, 2:feature_size) ones(train_size, 1)];
    trainl = training_set(1:train_size, 1:1);
    testf = [training_set(train_size+1:data_size, 2:feature_size) ones(train_size, 1)];
    testl = training_set(train_size+1:data_size, 1:1);
  else
    trainf = [training_set(1:train_size, 1:feature_size-1) ones(train_size, 1)];
    trainl = training_set(1:train_size, feature_size:feature_size);
    testf = [training_set(train_size+1:data_size, 1:feature_size-1) ones(train_size, 1)];
    testl = training_set(train_size+1:data_size, feature_size:feature_size);
  end
end
