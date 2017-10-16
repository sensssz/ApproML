function [ params, time, gradient_value, error_bound, cc ] = RegressionSample( regression, sample_error, ftr, lbl, sample_rate, lambda, probability )
  num_examples = size(lbl, 1);
  sample_size = int32(num_examples * sample_rate);
  fsample = datasample(ftr, sample_size, 'Replace', false);
  lsample = datasample(lbl, sample_size, 'Replace', false);
  [ params, time, gradient_value ] = regression(fsample, lsample, lambda);
  [ error_bound, cc ] = sample_error(fsample, lsample, params, lambda, probability);
end
