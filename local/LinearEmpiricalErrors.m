function [ linear_prediction_errors, linear_model_errors ] = EmpiricalErrors( original_model, models, testset )
  original_prediction = testset * original_model;
  num_tests = size(testset, 1);
  num_models = size(models, 2);
  linear_prediction_errors = [];
  linear_model_errors = [];
  for i = 1:num_models
    model = models(:, i:i);
    prediction = testset * model;
    linear_prediction_errors = [linear_prediction_errors (prediction - original_prediction) ./ original_prediction];
    linear_model_errors = [linear_model_errors (model - original_model) ./ original_model];
  end
end
