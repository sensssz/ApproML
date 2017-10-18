lambda = 1e-6;
[logistic_full_params, logistic_full_time, logistic_full_gvalue] = LogisticRegression(trainf, trainl, lambda);
[linear_full_params, linear_full_time, linear_full_gvalue] = LinearRegression(trainf, trainl, lambda);
sampling_rates = [0.01 0.02 0.05 0.08 0.1 0.2 0.5 0.8];
[logistic_params, logistic_sampling_times, logistic_training_times, logistic_gvalues, logistic_error_bounds, logistic_ccs] = CollectTrainingStat(@LogisticRegressionSample, trainf, trainl, sampling_rates);
[linear_params, linear_sampling_times, linear_training_times, linear_gvalues, linear_error_bounds, linear_ccs] = CollectTrainingStat(@LinearRegressionSample, trainf, trainl, sampling_rates);
logistic_plot_training_times = [mean(logistic_training_times, 3) logistic_full_time];
linear_plot_training_times = [mean(linear_training_times, 3) linear_full_time];
[logistic_prediction_errors_full_model, logistic_prediction_errors_truth, logistic_model_errors] = LogisticEmpiricalErrors(logistic_full_params, logistic_params, trainf);
[linear_prediction_errors_full_model, linear_prediction_errors_truth, linear_model_errors] = LinearEmpiricalErrors(linear_full_params, linear_params, trainf);
PlotTrainingTime([sampling_rates 1], logistic_plot_training_times, 'logistic');
PlotTrainingTime([sampling_rates 1], linear_plot_training_times, 'linear');
PlotPredictionError(sampling_rates, logistic_prediction_errors_full_model, logistic_prediction_errors_truth, 'logistic');
PlotPredictionError(sampling_rates, linear_prediction_errors_full_model, linear_prediction_errors_truth, 'linear');
PlotModelError(sampling_rates, logistic_full_params, logistic_model_errors, 'logistic');
PlotModelError(sampling_rates, linear_full_params, linear_model_errors, 'linear');
