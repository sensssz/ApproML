function [ linear_prediction_errors, linear_model_errors ] = EmpiricalErrors( original_model, models, testset )
  original_prediction = testset * original_model;
  num_tests = size(testset, 1);
  num_models = size(models, 2);
  linear_prediction_errors = zeros(1, num_models);
  linear_model_errors = [];
  for i = 1:num_models
    model = models(:, i:i);
    predictions = testset * model;
    linear_prediction_errors(1, i) = abs(mean((predictions - original_prediction) ./ original_prediction));
    linear_model_errors = [linear_model_errors abs(model - original_model ./ original_model)];
  end
end
