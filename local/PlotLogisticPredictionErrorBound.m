function PlotLogisticPredictionErrorBound( original_model, sampling_rates, models, error_bounds, testf )
  PlotBoundingProbabilities(original_model, sampling_rates, models, error_bounds, testf);
  tests = zeros(6, size(testf, 2));
  tests(1:1, :) = testf(1002:1002, :);
  tests(2:2, :) = testf(10902445:10902445, :);
  tests(3:3, :) = testf(2621:2621, :);
  tests(4:4, :) = testf(12431310:12431310, :);
  tests(5:5, :) = testf(8556:8556, :);
  tests(6:6, :) = testf(7046:7046, :);
  PlotVisualErrorBound(original_model, sampling_rates, models, error_bounds, tests);
end

function PlotBoundingProbabilities( original_model, sampling_rates, models, error_bounds, testf )
  num_tests = size(testf, 1);
  num_models = size(models, 2);
  num_runs = size(models, 3);
  original_prediction = sigmoid(testf * original_model);
  prediction_probabilities = zeros(num_runs, num_models);
  undeterminable_probabilities = zeros(num_runs, num_models);
  abs_testf = abs(testf);
  for i = 1:num_runs
    for j = 1:num_models
      model = models(:, j:j, i:i);
      error_bound = error_bounds(:, j:j, i:i);
      min_prediction = sigmoid(testf * model - abs_testf * error_bound);
      max_prediction = sigmoid(testf * model + abs_testf * error_bound);
      determinable = (min_prediction < 0.5 & max_prediction < 0.5) |...
                     (min_prediction > 0.5 & max_prediction > 0.5);
      num_indeterminable = sum(~determinable);
      undeterminable_probabilities(i, j) = num_indeterminable / num_tests;

      correct = sum(determinable & min_prediction < 0.5 & original_prediction < 0.5) +...
                sum(determinable & min_prediction > 0.5 & original_prediction > 0.5);
      prediction_probabilities(i, j) = correct / (num_tests - num_indeterminable);
    end
  end

  num_sampling_rates = size(sampling_rates, 2);

  % Plot prediction probability
  plot(mean(prediction_probabilities) * 100);
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
  figname = 'logistic_prediction_error_bound';
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;

  % Plot undeterminable probability
  plot(mean(undeterminable_probabilities) * 100);
  xticklabels = cell(num_sampling_rates);
  xticklabels = xticklabels(1, :);
  for i = 1:num_sampling_rates
    xticklabels{i} = strcat(num2str(sampling_rates(1, i) * 100), '%');
  end
  set(gca,'FontSize',22);
  set(gca,'XTick',linspace(1, num_sampling_rates, num_sampling_rates));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Sampling Rate');
  ylabel({'Probability of Prediction', 'Being Undeterminable (%)'});
  figname = 'logistic_undeterminable_probability';
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;
end

function PlotVisualErrorBound( original_model, sampling_rates, models, error_bounds, testf )
  num_sampling_rates = size(sampling_rates, 2);
  abs_testf = abs(testf);
  num_tests = size(testf, 1);
  y = sigmoid(testf * original_model);
  colors = get(gca, 'colororder');
  for i = 1:num_sampling_rates
    xaxis = (1:num_tests)' + (num_tests+1) * (i-1);
    model = models(:, i:i, 1:1);
    error_bound = error_bounds(:, i:i, 1:1);
    yneg = y - sigmoid(testf * model - abs_testf * error_bound);
    ypos = sigmoid(testf * model + abs_testf * error_bound) - y;
    errorbar(xaxis, y, yneg, ypos, 'x', 'color', colors(1:1, :));
    hold on;
  end
  for i = 1:num_sampling_rates-1
    index = i * (num_tests + 1);
    plot([index, index], ylim, '--r');
  end
  plot(xlim, [0.5, 0.5], '--r');
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
  figname = strcat('logistic_prediction_error_bound_visual');
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;
end