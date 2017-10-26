function PlotLogisticPredictionErrorBound( original_model, sampling_rates, models, error_bounds, testf )
  PlotBoundingProbabilities(original_model, sampling_rates, models, error_bounds, testf);
  PlotVisalErrorBound(original_model, sampling_rates, models, error_bounds, testf);
end

function PlotBoundingProbabilities( original_model, sampling_rates, models, error_bounds, testf )
  num_tests = size(testf, 1);
  num_models = size(models, 2);
  num_runs = size(models, 3);
  original_prediction = sigmoid(testf * original_model);
  bounding_probabilities = zeros(num_runs, num_models);
  abs_testf = abs(testf);
  for i = 1:num_runs
    for j = 1:num_models
      model = models(:, j:j, i:i);
      error_bound = error_bounds(:, j:j, i:i);
      min_prediction = sigmoid(testf * model - abs_testf * error_bound);
      max_prediction = sigmoid(testf * model + abs_testf * error_bound);
      bounded = (min_prediction <= original_prediction &...
                 max_prediction >= original_prediction) |...
                (min_prediction >= original_prediction &...
                 max_prediction <= original_prediction);
      success = sum(bounded & min_prediction < 0.5 & max_prediction < 0.5) +...
                sum(bounded & min_prediction > 0.5 & max_prediction > 0.5);
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
  saveas(gcf, 'logistic_prediction_error_bound.png');
  close all;
end

function PlotVisalErrorBound( original_model, sampling_rates, models, error_bounds, testf )
  num_sampling_rates = size(sampling_rates, 2);
  abs_testf = abs(testf);
  num_tests = size(testf, 1);
  y = sigmoid(testf * original_model);
  for i = 1:num_sampling_rates
    xaxis = (1:num_tests)' + (num_tests+1) * (i-1);
    model = models(:, i:i, 1:1);
    error_bound = error_bounds(:, i:i, 1:1);
    yneg = sigmoid(testf * model - abs_testf * error_bound);
    ypos = sigmoid(testf * model + abs_testf * error_bound);
    errorbar(xaxis, y, yneg, ypos, 'bo');
    hold on;
  end
  for i = 1:num_sampling_rates-1
    index = i * (num_tests + 1);
    plot([index, index], ylim, '--r');
  end
  plot([num_tests + 1, num_tests + 1], ylim, '--r');
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
  saveas(gcf, strcat('logistic_model_error_bound_visual.png'));
  close all;
end