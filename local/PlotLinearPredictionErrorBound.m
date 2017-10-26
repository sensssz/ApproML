function PlotLinearPredictionErrorBound( original_model, sampling_rates, models, error_bounds, testf )
  num_tests = size(testf, 1);
  num_models = size(models, 2);
  num_runs = size(models, 3);
  original_prediction = testf * original_model;
  bounding_probabilities = zeros(num_runs, num_models);
  for i = 1:num_runs
    for j = 1:num_models
      model = models(:, j:j, i:i);
      error_bound = error_bounds(:, j:j, i:i);
      min_prediction = testf * (model - error_bound);
      max_prediction = testf * (model + error_bound);
      success = sum((min_prediction <= original_prediction) & (max_prediction >= original_prediction));
      bounding_probabilities(i, j) = success / num_tests;
    end
  end

  num_sampling_rates = size(sampling_rates, 2);
  plot(mean(bounding_probabilities) * 100 / num_runs);
  xticklabels = cell(num_sampling_rates);
  xticklabels = xticklabels(1, :);
  for i = 1:num_sampling_rates
      xticklabels{i} = strcat(num2str(sampling_rates(1, i) * 100), '%');
  end
  set(gca,'FontSize',22);
  set(gca,'XTick',linspace(1, num_sampling_rates, num_sampling_rates));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Sampling Rate');
  ylabel({'Probability of Error Bound', 'Holding for Sample Prediction (%)'});
  saveas(gcf, 'linear_prediction_error_bound.png');
  close all;

end