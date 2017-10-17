function [ prediction_errors, model_errors ] = EmpiricalErrors( original_model, models, testset )
  original_prediction = testset * original_model;
  num_tests = size(testset, 1);
  num_models = size(models, 2);
  prediction_errors = zeros(1, num_models);
  model_errors = [];
  for i = 1:num_models
    model = models(:, i:i);
    predictions = testset * model;
    prediction_errors(1, i) = sum(predictions ~= original_prediction) / num_tests;
    model_errors = [model_errors abs(model - original_model) ./ original_model];
  end
end
