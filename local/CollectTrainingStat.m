function [ params, sampling_times, training_times, gvalues, error_bounds, ccs ] = CollectTrainingStat( regression, trainf, trainl, sampling_rates )
  num_runs = 100;
  num_sampling_rates = size(sampling_rates, 2);
  num_features = size(trainf, 2);
  params = zeros(num_features, num_sampling_rates, num_runs);
  sampling_times = zeros(1, num_sampling_rates, num_runs);
  training_times = zeros(1, num_sampling_rates, num_runs);
  gvalues = zeros(num_features, num_sampling_rates, num_runs);
  error_bounds = zeros(num_features, num_sampling_rates, num_runs);
  ccs = zeros(num_features, num_features, num_sampling_rates, num_runs);
  lambda = 1e-6;
  probability = 0.01;
  for i = 1:num_sampling_rates
    sampling_rate = sampling_rates(1, i);
    for j = 1:100
      [param, sampling_time, training_time, gvalue, error_bound, cc] = regression(trainf, trainl, sampling_rate, lambda, probability);
      params(:, i:i, j) = param;
      sampling_times(1, i, j) = sampling_time;
      training_times(1, i, j) = training_time;
      gvalues(:, i:i, j) = gvalue;
      error_bounds(:, i:i, j) = error_bound;
      ccs(:, :, i:i, j) = cc;
    end
  end
end
