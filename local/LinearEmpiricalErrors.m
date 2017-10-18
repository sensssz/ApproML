function [ linear_prediction_errors_avg, linear_model_errors_avg ] = LinearEmpiricalErrors( original_model, models, testset )
  original_prediction = testset * original_model;
  num_features = size(modeos, 1);
  num_models = size(models, 2);
  num_runs = size(models, 3);
  linear_prediction_errors = zeros(1, num_models, num_runs);
  linear_model_errors = zeros(num_features, num_models, num_runs);
  for i = 1:num_models
    for j = 1:num_runs
      model = models(:, i:i, j);
      predictions = testset * model;
      linear_prediction_errors(1, i, j) = abs(mean((predictions - original_prediction) ./ original_prediction));
      linear_model_errors(:, i:i, j) = abs((model - original_model) ./ original_model);
    end
  end
  linear_prediction_errors_avg = mean(linear_prediction_errors, 3);
  linear_model_errors_avg = mean(linear_model_errors, 3);
end
