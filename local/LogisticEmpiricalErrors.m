function [ logistic_prediction_errors_full_model, logistic_prediction_errors_truth, logistic_model_errors ] = LogisticEmpiricalErrors( original_model, models, testf, testl )
  original_prediction = sigmoid(testf * original_model) > 0.5;
  num_tests = size(testf, 1);
  num_features = size(models, 1);
  num_models = size(models, 2);
  num_runs = size(models, 3);
  logistic_prediction_errors_full_model = zeros(num_models, 1, num_runs);
  logistic_prediction_errors_truth = zeros(num_models, 1, num_runs);
  logistic_model_errors = zeros(num_features, num_models, num_runs);
  for i = 1:num_models
    for j = 1:num_runs
      model = models(:, i:i, j);
      prediction = sigmoid(testf * model) > 0.5;
      logistic_prediction_errors_full_model(i, 1, j) = sum(prediction ~= original_prediction) / num_tests;
      logistic_prediction_errors_truth(i, 1, j) = sum(prediction ~= testl) / num_tests;
      logistic_model_errors(:, i:i, j) = abs((model - original_model) ./ original_model);
    end
  end
end
