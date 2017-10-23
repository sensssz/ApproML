function [ trainf, trainl, testf, testl ] = ReadDataset( filename, label_col, test_portion )
  training_set = csvread(filename);
  [row, col] = size(training_set);
  tests = int32(test_portion * row);
  testf = [training_set(1:tests, 1:col-1) ones(tests, 1)];
  testl = training_set(1:tests, col:col);
  training_set(1:tests, :) = [];
  row = row - tests;
  trainl = training_set(1:row, col:col);
  training_set(:, col) = 1;
  trainf = training_set;
end