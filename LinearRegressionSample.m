function [ params, time, gradient_value, error_bound, cc ] = LinearRegressionSample( ftr, lbl, sample_rate, lambda, probability )
  num_examples = size(lbl, 1);
  sample_size = int32(num_examples * sample_rate);
  rand_perm = randperm(num_examples);
  fsample = ftr(rand_perm(1:sample_size), :);
  lsample = lbl(rand_perm(1:sample_size), :);
  [ params, time, gradient_value ] = LinearRegression(fsample, lsample, lambda);
  [ error_bound, cc ] = LinearRegressionSampleError(fsample, lsample, params, lambda, probability);
end
