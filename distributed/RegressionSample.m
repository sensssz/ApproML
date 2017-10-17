function [ params, sampling_time, regression_time, gradient_value, error_bound, cc ] = RegressionSample( regression, sample_error, ftr, lbl, sample_rate, lambda, probability )
  tic;
  num_examples = size(lbl, 1);
  if sample_rate < 1
    sample_size = int32(num_examples * sample_rate);
    rand_perm = randperm(num_examples, sample_size);
    fsample = ftr(rand_perm, :);
    lsample = lbl(rand_perm, :);
  else
    fsample = ftr;
    lsample = lbl;
  end
  sampling_time = toc;
  [ params, regression_time, gradient_value ] = regression(fsample, lsample, lambda);
  [ error_bound, cc ] = sample_error(fsample, lsample, params, lambda, probability);
end
