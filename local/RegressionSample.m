function [ params, sampling_time, regression_time, gradient_value, error_bound, cc ] = RegressionSample( regression, sample_error, ftr, lbl, sample_rate, lambda, probability )
  tic;
  num_examples = size(lbl, 1);
  sample_size = int32(num_examples * sample_rate);
  rand_perm = randperm(num_examples);
  fsample = ftr(rand_perm(1:sample_size), :);
  lsample = lbl(rand_perm(1:sample_size), :);
  sampling_time = toc;
  [ params, regression_time, gradient_value ] = regression(fsample, lsample, lambda);
  [ error_bound, cc ] = sample_error(fsample, lsample, params, lambda, probability);
end
