function [ logistic_prediction_errors, logistic_model_errors ] = LogisticEmpiricalErrors( original_model, models, testset )
  original_prediction = sigmoid(testset * original_model) > 0.5;
  num_tests = size(testset, 1);
  num_models = size(models, 2);
  logistic_prediction_errors = zeros(1, num_models);
  logistic_model_errors = [];
  for i = 1:num_models
    model = models(:, i:i);
    prediction = sigmoid(testset * model) > 0.5;
    logistic_prediction_errors(1, i) = sum(prediction ~= original_prediction) / num_tests;
    logistic_model_errors = [logistic_model_errors abs((model - original_model) ./ original_model)];
  end
end
