function PlotLinearPredictionErrorBound( original_model, sampling_rates, models, error_bounds, testf )
  num_models = size(models, 2);
  num_runs = size(models, 3);
  original_prediction = testf * original_model;
  bounding_probabilities = zeros(1, num_models);
  for i = 1:num_runs
    for j = 1:num_models
      model = models(:, j:j, i:i);
      error_bound = error_bounds(:, j:j, i:i);
      min_prediction = testf * (model - error_bound);
      max_prediction = testf * (model + error_bound);
      if sum(min_prediction > original_prediction) == 0 && sum(max_prediction < original_prediction) == 0
        bounding_probabilities(1, j) = bounding_probabilities(1, j) + 1;
      end
    end
  end

  num_sampling_rates = size(sampling_rates, 2);
  plot(bounding_probabilities * 100 / num_runs);
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