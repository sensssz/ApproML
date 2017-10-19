function [ linear_prediction_errors_full_model, linear_prediction_errors_truth, linear_model_errors ] = LinearEmpiricalErrors( original_model, models, testset, testlabel )
  original_prediction = testset * original_model;
  num_features = size(models, 1);
  num_models = size(models, 2);
  num_runs = size(models, 3);
  linear_prediction_errors_full_model = zeros(num_models, 1, num_runs);
  linear_prediction_errors_truth = zeros(num_models, 1, num_runs);
  linear_model_errors = zeros(num_features, num_models, num_runs);
  for i = 1:num_models
    for j = 1:num_runs
      model = models(:, i:i, j);
      predictions = testset * model;
      linear_prediction_errors_full_model(i, 1, j) = mean(abs(predictions - original_prediction));
      linear_prediction_errors_truth(i, 1, j) = mean(abs(predictions - testlabel));
      linear_model_errors(:, i:i, j) = abs((model - original_model) ./ original_model);
    end
  end
end
