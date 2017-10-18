function [ logistic_prediction_errors_full_model_avg, logistic_prediction_errors_truth_avg, logistic_model_errors_avg ] = LogisticEmpiricalErrors( original_model, models, testset, testlabel )
  original_prediction = sigmoid(testset * original_model) > 0.5;
  num_tests = size(testset, 1);
  num_features = size(models, 1);
  num_models = size(models, 2);
  num_runs = size(models, 3);
  logistic_prediction_errors_full_model = zeros(1, num_models, num_runs);
  logistic_prediction_errors_truth = zeros(1, num_models, num_runs);
  logistic_model_errors = zeros(num_features, num_models, num_runs);
  for i = 1:num_models
    for j = 1:num_runs
      model = models(:, i:i, j);
      prediction = sigmoid(testset * model) > 0.5;
      logistic_prediction_errors_full_model(1, i, j) = sum(prediction ~= original_prediction) / num_tests;
      logistic_prediction_errors_truth(1, i, j) = sum(prediction ~= testlabel) / num_tests;
      logistic_model_errors(:, i:i, j) = abs((model - original_model) ./ original_model);
    end
  end
  logistic_prediction_errors_full_model_avg = mean(logistic_prediction_errors_full_model, 3);
  logistic_prediction_errors_truth_avg = mean(logistic_prediction_errors_truth, 3);
  logistic_model_errors_avg = mean(logistic_model_errors, 3);
end
