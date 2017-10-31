lambda = 1e-6;
% sampling_rates = [0.01 0.02 0.05 0.08 0.1 0.2 0.5 0.8];
sampling_rates = [0.01 0.02 0.05 0.1 0.2 0.5];
deltas = [0.01 0.02 0.05 0.1 0.2];

if do_logistic
  % Logistic regression
  [full_params, full_time, full_gvalue] = LogisticRegression(trainf, trainl, lambda);
  [params, sampling_times, training_times, gvalues, error_bounds, ccs] = CollectTrainingStat(@LogisticRegressionSample, trainf, trainl, sampling_rates);
  plot_training_times = [mean(training_times, 3) full_time];
  [prediction_errors_full_model, prediction_errors_truth, model_errors] = LogisticEmpiricalErrors(full_params, params, testf, testl);
  PlotTrainingTime([sampling_rates 1], plot_training_times, 'logistic');
  PlotPredictionError(sampling_rates, prediction_errors_full_model, 'Full Model', 'full_model');
  PlotPredictionError(sampling_rates, prediction_errors_truth, 'Ground Truth', 'ground_truth');
  PlotModelError(sampling_rates, full_params, model_errors, 'logistic');
  PlotModelErrorBound(full_params, sampling_rates, params, error_bounds, 'logistic');
  PlotLogisticPredictionErrorBound(full_params, sampling_rates, params, error_bounds, testf);
  PlotLogisticErrorBoundSize(sampling_rates, params, error_bounds, testf);

  [prob_params, prob_sampling_times, prob_training_times, prob_gvalues, prob_error_bounds, prob_ccs] = VaryProbability( @LogisticRegressionSample, deltas, trainf, trainl );
  PlotLogisticProbErrorBoundSize(deltas, full_params, prob_params, prob_error_bounds, testf);

  [bootstrap_params, sampling_times, bootstrap_training_times, bootstrap_model_error_bounds, bootstrap_prediction_error_bounds] = Bootstrap(full_params, sampling_rates, lambda, @LogisticRegression, @LogisticPredict, trainf, trainl, testf, testl, 'bootstrap_logistic');
end

if do_linear
  % Linear regression
  [full_params, full_time, full_gvalue] = LinearRegression(trainf, trainl, lambda);
  [params, sampling_times, training_times, gvalues, error_bounds, ccs] = CollectTrainingStat(@LinearRegressionSample, trainf, trainl, sampling_rates);
  plot_training_times = [mean(training_times, 3) full_time];
  [prediction_errors_full_model, prediction_errors_truth, model_errors] = LinearEmpiricalErrors(full_params, params, testf, testl);
  PlotTrainingTime([sampling_rates 1], plot_training_times, 'linear');
  PlotPredictionError(sampling_rates, prediction_errors_full_model, 'Full Model', 'full_model');
  PlotPredictionError(sampling_rates, prediction_errors_truth, 'Ground Truth', 'ground_truth');
  PlotModelError(sampling_rates, full_params, model_errors, 'linear');
  PlotModelErrorBound(full_params, sampling_rates, params, error_bounds, 'linear');
  PlotLinearPredictionErrorBound(full_params, sampling_rates, params, error_bounds, testf);
  PlotLinearErrorBoundSize(sampling_rates, params, error_bounds, testf);

  [prob_params, prob_sampling_times, prob_training_times, prob_gvalues, prob_error_bounds, prob_ccs] = VaryProbability( @LinearRegressionSample, deltas, trainf, trainl );
  PlotLinearProbErrorBoundSize(deltas, full_params, prob_params, prob_error_bounds, testf);

  [bootstrap_params, sampling_times, bootstrap_training_times, bootstrap_model_error_bounds, bootstrap_prediction_error_bounds] = Bootstrap(full_params, sampling_rates, lambda, @LinearRegression, @LinearPredict, trainf, trainl, testf, testl, 'bootstrap_linear');
end
