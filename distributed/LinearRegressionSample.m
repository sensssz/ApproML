function [ params, time, gradient_value, error_bound, cc ] = LinearRegressionSample( ftr, lbl, sample_rate, lambda, probability )
  [ params, time, gradient_value, error_bound, cc ] = RegressionSample(@LinearRegression, @LinearRegressionSampleError, ftr, lbl, sample_rate, lambda, probability);
end
