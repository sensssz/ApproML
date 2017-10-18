function [ linear_prediction_errors_full_model_avg, linear_prediction_errors_truth_avg, linear_model_errors_avg ] = LinearEmpiricalErrors( original_model, models, testset, testlabel )
  original_prediction = testset * original_model;
  num_features = size(models, 1);
  num_models = size(models, 2);
  num_runs = size(models, 3);
  linear_prediction_errors_full_model = zeros(1, num_models, num_runs);
  linear_prediction_errors_truth = zeros(1, num_models, num_runs);
  linear_model_errors = zeros(num_features, num_models, num_runs);
  for i = 1:num_models
    for j = 1:num_runs
      model = models(:, i:i, j);
      predictions = testset * model;
      linear_prediction_errors_full_model(1, i, j) = abs(mean((predictions - original_prediction) ./ original_prediction));
      linear_prediction_errors_truth(1, i, j) = abs(mean((predictions - testlabel) ./ testlabel));
      linear_model_errors(:, i:i, j) = abs((model - original_model) ./ original_model);
    end
  end
  linear_prediction_errors_full_model_avg = mean(linear_prediction_errors_full_model, 3);
  linear_prediction_errors_truth_avg = mean(linear_prediction_errors_truth, 3);
  linear_model_errors_avg = mean(linear_model_errors, 3);
end
