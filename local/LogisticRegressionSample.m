function [ params, sampling_time, training_time,, gradient_value, error_bound, cc ] = LogisticRegressionSample( ftr, lbl, sample_rate, lambda, probability )
  [ params, sampling_time, training_time,, gradient_value, error_bound, cc ] = RegressionSample(@LogisticRegression, @LogisticRegressionSampleError, ftr, lbl, sample_rate, lambda, probability);
end
