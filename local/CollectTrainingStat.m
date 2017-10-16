function [ params, training_times, gvalues, error_bounds, ccs ] = CollectTrainingStat( regression, trainf, trainl, sampling_rates )
  num_sampling_rates = size(sampling_rates, 2);
  params = [];
  sampling_times = zeros(1, num_sampling_rates);
  training_times = zeros(1, num_sampling_rates);
  gvalues = [];
  error_bounds = [];
  ccs = [];
  lambda = 1e-6;
  probability = 0.01;
  for i = 1:num_sampling_rates
    sampling_rate = sampling_rates(1, i);
    [param, sampling_time, training_time, gvalue, error_bound, cc] = regression(trainf, trainl, sampling_rate, lambda, probability);
    params = [params param];
    training_times(1, i) = sampling_time;
    training_times(1, i) = training_time;
    gvalues = [gvalues gvalue];
    error_bounds = [error_bounds, error_bound];
    ccs = [ccs cc];
  end
end
