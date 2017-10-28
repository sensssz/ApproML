function PlotLinearPredictionErrorBound( original_model, sampling_rates, models, error_bounds, testf )
  PlotBoundingProbabilities(original_model, sampling_rates, models, error_bounds, testf);
  PlotVisualErrorBound(original_model, sampling_rates, models, error_bounds, testf(100:106, :));
end

function PlotBoundingProbabilities( original_model, sampling_rates, models, error_bounds, testf )
  num_tests = size(testf, 1);
  num_models = size(models, 2);
  num_runs = size(models, 3);
  abs_testf = abs(testf);
  original_prediction = testf * original_model;
  bounding_probabilities = zeros(num_runs, num_models);
  for i = 1:num_runs
    for j = 1:num_models
      model = models(:, j:j, i:i);
      error_bound = error_bounds(:, j:j, i:i);
      min_prediction = testf * model - abs_testf * error_bound;
      max_prediction = testf * model + abs_testf * error_bound;
      success = sum((min_prediction <= original_prediction) & (max_prediction >= original_prediction));
      bounding_probabilities(i, j) = success / num_tests;
    end
  end

  num_sampling_rates = size(sampling_rates, 2);
  plot(mean(bounding_probabilities) * 100);
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
  figname = 'linear_prediction_error_bound';
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;

end

function PlotVisualErrorBound( original_model, sampling_rates, models, error_bounds, testf )
  num_sampling_rates = size(sampling_rates, 2);
  abs_testf = abs(testf);
  num_tests = size(testf, 1);
  y = testf * original_model;
  colors = get(gca, 'colororder');
  for i = 1:num_sampling_rates
    xaxis = (1:num_tests)' + (num_tests+1) * (i-1);
    model = models(:, i:i, 1:1);
    error_bound = error_bounds(:, i:i, 1:1);
    yneg = y - testf * model - abs_testf * error_bound;
    ypos = testf * model + abs_testf * error_bound - y;
    errorbar(xaxis, y, yneg, ypos, 'x', 'color', colors(1:1, :));
    hold on;
  end
  for i = 1:num_sampling_rates-1
    index = i * (num_tests + 1);
    plot([index, index], ylim, '--r');
  end
  plot([num_tests + 1, num_tests + 1], ylim, '--r');
  xticklabels = cell(num_sampling_rates);
  xticklabels = xticklabels(1, :);
  for j = 1:num_sampling_rates
      xticklabels{j} = strcat(num2str(sampling_rates(1, j) * 100), '%');
  end
  set(gca,'FontSize',22);
  set(gca,'XTick',linspace((num_tests+1)/2, (num_tests+1)*num_sampling_rates-num_tests/2, num_sampling_rates));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Sampling Rate');
  ylabel({'Visualization of Error', 'Bounds for Predictions'});
  figname = strcat('linear_prediction_error_bound_visual');
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;
end
