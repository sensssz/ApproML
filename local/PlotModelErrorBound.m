function PlotModelErrorBound( original_model, sampling_rates, models, error_bounds, prefix )
  PlotBoundingProbabilities(original_model, sampling_rates, models, error_bounds, prefix);
  PlotVisalErrorBound(original_model, sampling_rates, models, error_bounds, prefix);
end

function PlotBoundingProbabilities( original_model, sampling_rates, models, error_bounds, prefix )
  num_models = size(models, 1);
  num_runs = size(models, 3);
  bounding_probabilities = zeros(1, num_models);
  for i = 1:num_runs
    for j = 1:num_models
      model = models(:, j:j, i:i);
      error_bound = error_bounds(:, j:j, i:i);
      min_model = model - error_bound;
      max_model = model - error_bound;
      if sum(min_model >= original_model) == 0 && sum(max_model <= original_model) == 0
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
  num_sampling_rates = size(sampling_rates, 2);
  xaxis = (1:num_sampling_rates)';
  [~, sorted_indices] = sort(abs(original_model), 'descend');
  model_size = size(original_model, 1);
  for i = 1:3
    original_index = sorted_indices(i, 1);
    min_bound = min_bounds(original_index:original_index, :);
    max_bound = max_bounds(original_index:original_index, :);
    bound_patch = patch([xaxis; xaxis(end:-1:1); xaxis(1)], [min_bound; max_bound(end:-1:1); min_bound(1)], 'r');
    hold on;
    error_line = line(xaxis, ones(1, model_size) * original_model(original_index, 1));
    hold off;
    set(bound_patch, 'facecolor', [1 0.8 0.8], 'edgecolor', 'none');
    set(error_line, 'color', 'r', 'marker', 'x');
    xticklabels = cell(num_sampling_rates);
    xticklabels = xticklabels(1, :);
    for i = 1:num_sampling_rates
        xticklabels{i} = strcat(num2str(sampling_rates(1, i) * 100), '%');
    end
    set(gca,'XTick',linspace(1, num_sampling_rates, num_sampling_rates));
    set(gca, 'xticklabel', xticklabels);
    xlabel('Sampling Rate');
    ylabel('Optimal Parameters And Bounds');
    saveas(gcf, strcat(prefix, '_error_bound_visual.png'));
    close all;
  end
end
