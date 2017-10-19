function PlotModelErrorBound( original_model, sampling_rates, models, error_bounds, prefix )
  PlotBoundingProbabilities(original_model, sampling_rates, models, error_bounds, prefix);
  close all;
  PlotVisalErrorBound(original_model, sampling_rates, models, error_bounds, prefix);
end

function PlotBoundingProbabilities( original_model, sampling_rates, models, error_bounds, prefix )
  num_models = size(models, 2);
  num_runs = size(models, 3);
  bounding_probabilities = zeros(1, num_models);
  for i = 1:num_runs
    for j = 1:num_models
      model = models(:, j:j, i:i);
      error_bound = error_bounds(:, j:j, i:i);
      min_model = model - error_bound;
      max_model = model + error_bound;
      if sum(min_model > original_model) == 0 && sum(max_model < original_model) == 0
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
  set(gca,'XTick',linspace(1, num_sampling_rates, num_sampling_rates));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Sampling Rate');
  ylabel('Probability of Error Bounding for Sample Model (%)');
  saveas(gcf, strcat(prefix, '_error_bound.png'));
  close all;
end

function PlotVisalErrorBound( original_model, sampling_rates, models, error_bounds, prefix )
  min_bounds = mean(models - error_bounds, 3);
  max_bounds = mean(models + error_bounds, 3);
  mean_models = mean(models, 3);
  mean_errors = mean(error_bounds, 3);
  num_sampling_rates = size(sampling_rates, 2);
  xaxis = (1:num_sampling_rates)';
  [~, sorted_indices] = sort(abs(original_model), 'descend');
  for i = 1:3
    original_index = sorted_indices(i, 1);
    model = (mean_models(original_index:original_index, :))';
    error_bound = (mean_errors(original_index:original_index, :))';
    errorbar(xaxis, model, error_bound, 'r-x');
    hold on;
    line(xaxis, ones(num_sampling_rates, 1) * original_model(original_index, 1));
    hold off;
    % set(bound, 'facecolor', [1 0.8 0.8], 'edgecolor', 'none');
    % set(error_line, 'color', 'r', 'marker', 'x');
    xticklabels = cell(num_sampling_rates);
    xticklabels = xticklabels(1, :);
    for j = 1:num_sampling_rates
        xticklabels{j} = strcat(num2str(sampling_rates(1, j) * 100), '%');
    end
    set(gca,'XTick',linspace(1, num_sampling_rates, num_sampling_rates));
    set(gca, 'xticklabel', xticklabels);
    xlabel('Sampling Rate');
    ylabel(['Optimal Parameters And Bounds for ', num2str(i), OrdinalSuffix(i) ,' most important dimension']);
    saveas(gcf, strcat(prefix, '_error_bound_visual_', num2str(i), '.png'));
    close all;
  end
end

function [ suffix ] = OrdinalSuffix( i )
  switch i
    case 1
      suffix = 'st';
    case 2
      suffix = 'nd';
    case 3
      suffix = 'rd';
    otherwise
      suffix = 'th';
  end
end
