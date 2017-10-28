function [ prob_params, prob_sampling_times, prob_training_times, prob_gvalues, prob_error_bounds, prob_ccs ] = VaryProbability( regression, deltas, trainf, trainl )
  sampling_rate = 0.01;
  lambda = 1e-6;
  num_features = size(trainf, 2);
  num_deltas = size(deltas, 2);
  prob_params = zeros(num_features, num_deltas);
  prob_sampling_times = zeros(1, num_deltas);
  prob_training_times = zeros(1, num_deltas);
  prob_gvalues = zeros(num_features, num_deltas);
  prob_error_bounds = zeros(num_features, num_deltas);
  prob_ccs = zeros(num_features, num_features, num_deltas);

  for i = 1:num_deltas
    probability = deltas(1, i);
    [param, sampling_time, training_time, gvalue, error_bound, cc] = regression(trainf, trainl, sampling_rate, lambda, probability);
    prob_params(:, i:i) = param;
    prob_sampling_times(1, i) = sampling_time;
    prob_training_times(1, i) = training_time;
    prob_gvalues(:, i:i) = gvalue;
    prob_error_bounds(:, i:i) = error_bound;
    prob_ccs(:, :, i:i) = cc;
  end
end