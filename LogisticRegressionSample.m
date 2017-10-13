function [ params, time, gradient_value, error_bound, cc ] = LogisticRegressionSample( ftr, lbl, sample_rate, lambda, probablity )
  num_examples = size(lbl, 1);
  sample_size = num_examples * sample_rate;
  rand_perm = randperm(num_examples);
  fsample = ftr(rand_perm(1:sample_size), :);
  lsample = lbl(rand_perm(1:sample_size), :);
  [ params, time, gradient_value ] = LogisticRegression(fsample, lsample, lambda);
  [ error_bound, cc ] = LogisticRegressionSampleError(fsample, lsample, params, lambda, probablity);
end
