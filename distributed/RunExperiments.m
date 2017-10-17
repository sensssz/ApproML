  [logistic_full_params, logistic_full_time, ~] = LogisticRegression(trainf, trainl, lambda);
  [linear_full_params, linear_full_time, ~] = LinearRegression(trainf, trainl, lambda);
  sampling_rates = [0.01 0.02 0.05 0.08 0.1 0.2 0.5 0.8];
  [logistic_params, logistic_training_times, ~, logistic_error_bounds, logistic_ccs] = CollectTrainingStat(@LogisticRegressionSample, trainf, trainl, sampling_rates);
  [linear_params, linear_training_times, ~, linear_error_bounds, linear_ccs] = CollectTrainingStat(@LinearRegressionSample, trainf, trainl, sampling_rates);
  logistic_training_times = [logistic_training_times logistic_full_time];
  linear_training_times = [linear_training_times linear_full_time];
  PlotTrainingTime(sampling_rates, logistic_training_times, 'logistic');
  PlotTrainingTime(sampling_rates, linear_training_times, 'linear');
