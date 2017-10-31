function [ prob_params, prob_sampling_times, prob_training_times, prob_gvalues, prob_error_bounds, prob_ccs ] = VaryProbability( regression, deltas, trainf, trainl )
  sampling_rate = 0.01;
  lambda = 1e-6;
  num_runs = 100;
  num_features = size(trainf, 2);
  num_deltas = size(deltas, 2);
  prob_params = zeros(num_features, num_deltas, num_runs);
  prob_sampling_times = zeros(1, num_deltas, num_runs);
  prob_training_times = zeros(1, num_deltas, num_runs);
  prob_gvalues = zeros(num_features, num_deltas, num_runs);
  prob_error_bounds = zeros(num_features, num_deltas, num_runs);
  prob_ccs = zeros(num_features, num_features, num_deltas, num_runs);

  for i = 1:num_deltas
    delta = deltas(1, i);
    for j = 1:num_runs
      [param, sampling_time, training_time, gvalue, error_bound, cc] = regression(trainf, trainl, sampling_rate, lambda, delta);
      prob_params(:, i:i, j:j) = param;
      prob_sampling_times(1, i, j) = sampling_time;
      prob_training_times(1, i, j) = training_time;
      prob_gvalues(:, i:i, j:j) = gvalue;
      prob_error_bounds(:, i:i, j:j) = error_bound;
      prob_ccs(:, :, i:i, j:j) = cc;
    end
  end
end