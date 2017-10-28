function [ prob_params, prob_sampling_times, prob_training_times, prob_gvalues, prob_error_bounds, prob_ccs ] = VaryProbability( regression, probabilities, trainf, trainl, params, sampling_times, training_times, gvalues, error_bounds, ccs )
  sampling_rate = 0.01;
  lambda = 1e-6;
  num_features = size(trainf, 2);
  num_probabilities = size(probabilities, 2);
  prob_params = zeros(num_features, num_probabilities);
  prob_sampling_times = zeros(1, num_probabilities);
  prob_training_times = zeros(1, num_probabilities);
  prob_gvalues = zeros(num_features, num_probabilities);
  prob_error_bounds = zeros(num_features, num_probabilities);
  prob_ccs = zeros(num_features, num_features, num_probabilities);

  prob_params(:, 1) = params(:, 1:1, 1:1);
  prob_sampling_times(:, 1) = sampling_times(:, 1:1, 1:1);
  prob_training_times(:, 1) = training_times(:, 1:1, 1:1);
  prob_gvalues(:, 1) = gvalues(:, 1:1, 1:1);
  prob_error_bounds(:, 1) = error_bounds(:, 1:1, 1:1);
  prob_ccs(:, :, 1) = ccs(:, :, 1:1, 1:1);

  for i = 2:num_probabilities
    probability = probabilities(1, i);
    [param, sampling_time, training_time, gvalue, error_bound, cc] = regression(trainf, trainl, sampling_rate, lambda, probability);
    prob_params(:, i:i) = param;
    prob_sampling_times(1, i) = sampling_time;
    prob_training_times(1, i) = training_time;
    prob_gvalues(:, i:i) = gvalue;
    prob_error_bounds(:, i:i) = error_bound;
    prob_ccs(:, :, i:i) = cc;
  end
end