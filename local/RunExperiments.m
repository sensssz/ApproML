lambda = 1e-6;
% sampling_rates = [0.01 0.02 0.05 0.08 0.1 0.2 0.5 0.8];
sampling_rates = [0.01 0.02 0.05 0.08 0.1];

if do_logistic
  % Logistic regression
  [logistic_full_params, logistic_full_time, logistic_full_gvalue] = LogisticRegression(trainf, trainl, lambda);
  [logistic_params, logistic_sampling_times, logistic_training_times, logistic_gvalues, logistic_error_bounds, logistic_ccs] = CollectTrainingStat(@LogisticRegressionSample, trainf, trainl, sampling_rates);
  logistic_plot_training_times = [mean(logistic_training_times, 3) logistic_full_time];
  [logistic_prediction_errors_full_model, logistic_prediction_errors_truth, logistic_model_errors] = LogisticEmpiricalErrors(logistic_full_params, logistic_params, testf, testl);
  PlotTrainingTime([sampling_rates 1], logistic_plot_training_times, 'logistic');
  PlotPredictionError(sampling_rates, logistic_prediction_errors_full_model, 'Full Model', 'logistic_full_model');
  PlotPredictionError(sampling_rates, logistic_prediction_errors_truth, 'Ground Truth', 'logistic_ground_truth');
  PlotModelError(sampling_rates, logistic_full_params, logistic_model_errors, 'logistic');
  PlotModelErrorBound(logistic_full_params, sampling_rates, logistic_params, logistic_error_bounds, 'logistic');
  PlotLogisticPredictionErrorBound(logistic_full_params, sampling_rates, logistic_params, logistic_error_bounds, testf);
  PlotLogisticErrorBoundSize(sampling_rates, logistic_params, logistic_error_bounds, testf);
end

if do_linear
  % Linear regression
  [linear_full_params, linear_full_time, linear_full_gvalue] = LinearRegression(trainf, trainl, lambda);
  [linear_params, linear_sampling_times, linear_training_times, linear_gvalues, linear_error_bounds, linear_ccs] = CollectTrainingStat(@LinearRegressionSample, trainf, trainl, sampling_rates);
  linear_plot_training_times = [mean(linear_training_times, 3) linear_full_time];
  [linear_prediction_errors_full_model, linear_prediction_errors_truth, linear_model_errors] = LinearEmpiricalErrors(linear_full_params, linear_params, testf, testl);
  PlotTrainingTime([sampling_rates 1], linear_plot_training_times, 'linear');
  PlotPredictionError(sampling_rates, linear_prediction_errors_full_model, 'Full Model', 'linear_full_model');
  PlotPredictionError(sampling_rates, linear_prediction_errors_truth, 'Ground Truth', 'linear_ground_truth');
  PlotModelError(sampling_rates, linear_full_params, linear_model_errors, 'linear');
  PlotModelErrorBound(linear_full_params, sampling_rates, linear_params, linear_error_bounds, 'linear');
  PlotLinearPredictionErrorBound(linear_full_params, sampling_rates, linear_params, linear_error_bounds, testf);
  PlotLinearErrorBoundSize(sampling_rates, linear_params, linear_error_bounds, testf);
end
