function PlotLinearProbErrorBoundSize( deltas, original_model, models, error_bounds, testf )
  PlotErrorBoundSize(deltas, models, error_bounds, testf);
  PlotBoundingProbabilities(deltas, original_model, models, error_bounds, testf);
end

function PlotErrorBoundSize( deltas, models, error_bounds, testf )
  num_models = size(models, 2);
  abs_testf = abs(testf);
  error_bound_sizes = zeros(1, num_models);
  for i = 1:num_models
    model = models(:, i:i);
    error_bound = error_bounds(:, i:i);
    min_prediction = testf * model - abs_testf * error_bound;
    max_prediction = testf * model + abs_testf * error_bound;
    error_bound_sizes(1, i) = mean(squeeze(max_prediction - min_prediction));
  end

  num_deltas = size(deltas, 2);
  plot(error_bound_sizes);
  xticklabels = cell(num_deltas);
  xticklabels = xticklabels(1, :);
  for i = 1:num_deltas
    xticklabels{i} = strcat(num2str(deltas(1, i) * 100), '%');
  end
  set(gca,'FontSize',22);
  set(gca,'XTick',linspace(1, num_deltas, num_deltas));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Value of \delta');
  ylabel({'Size of Error Bound'});
  figname = 'linear_delta_error_bound_size';
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;
end

function PlotBoundingProbabilities( original_model, deltas, models, error_bounds, testf )
  num_tests = size(testf, 1);
  num_models = size(models, 2);
  num_runs = size(models, 3);
  original_prediction = testf * original_model;
  prediction_probabilities = zeros(num_runs, num_models);
  undeterminable_probabilities = zeros(num_runs, num_models);
  abs_testf = abs(testf);
  for i = 1:num_runs
    for j = 1:num_models
      model = models(:, j:j, i:i);
      error_bound = error_bounds(:, j:j, i:i);
      min_prediction = testf * model - abs_testf * error_bound;
      max_prediction = testf * model + abs_testf * error_bound;
      determinable = (min_prediction < 0.5 & max_prediction < 0.5) |...
                     (min_prediction > 0.5 & max_prediction > 0.5);
      num_indeterminable = sum(~determinable);
      undeterminable_probabilities(i, j) = num_indeterminable / num_tests;

      correct = sum(determinable & min_prediction < 0.5 & original_prediction < 0.5) +...
                sum(determinable & min_prediction > 0.5 & original_prediction > 0.5);
      prediction_probabilities(i, j) = correct / (num_tests - num_indeterminable);
    end
  end

  num_deltas = size(deltas, 2);

  % Plot prediction probability
  plot(mean(prediction_probabilities) * 100);
  xticklabels = cell(num_deltas);
  xticklabels = xticklabels(1, :);
  for i = 1:num_deltas
    xticklabels{i} = strcat(num2str(deltas(1, i) * 100), '%');
  end
  set(gca,'FontSize',22);
  set(gca,'XTick',linspace(1, num_deltas, num_deltas));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Value of \delta');
  ylabel({'Probability of Error Bound', 'Holding for Sample Prediction (%)'});
  figname = 'linear_delta_prediction_error_bound';
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;

  % Plot undeterminable probability
  plot(mean(undeterminable_probabilities) * 100);
  xticklabels = cell(num_deltas);
  xticklabels = xticklabels(1, :);
  for i = 1:num_deltas
    xticklabels{i} = strcat(num2str(deltas(1, i) * 100), '%');
  end
  set(gca,'FontSize',22);
  set(gca,'XTick',linspace(1, num_deltas, num_deltas));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Value of \delta');
  ylabel({'Probability of Prediction', 'Being Undeterminable (%)'});
  figname = 'linear_delta_undeterminable_probability';
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;
end
