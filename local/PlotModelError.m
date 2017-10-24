function PlotModelError( sampling_rates, original_model, model_errors, prefix )
  close all;
  num_sampling_rates = size(sampling_rates, 2);
  [~, sorted_indices] = sort(abs(original_model), 'descend');
  xaxis = (1:num_sampling_rates)';
  min_errors = min(model_errors, [], 3) * 100;
  avg_errors = mean(model_errors, 3) * 100;
  max_errors = max(model_errors, [], 3) * 100;
  for i = 1:3
    original_index = sorted_indices(i, 1);
    min_errs = (min_errors(original_index:original_index, :))';
    avg_errs = (avg_errors(original_index:original_index, :))';
    max_errs = (max_errors(original_index:original_index, :))';
    bound_patch = patch([xaxis; xaxis(end:-1:1); xaxis(1)], [min_errs; max_errs(end:-1:1); min_errs(1)], 'r');
    hold on;
    error_line = line(xaxis, avg_errs);
    hold off;
    set(bound_patch, 'facecolor', [1 0.8 0.8], 'edgecolor', 'none');
    set(error_line, 'color', 'r', 'marker', 'x');
    xticklabels = cell(num_sampling_rates);
    xticklabels = xticklabels(1, :);
    for j = 1:num_sampling_rates
        xticklabels{j} = strcat(num2str(sampling_rates(1, j) * 100), '%');
    end
    set(gca,'FontSize',22);
    set(gca,'XTick',linspace(1, num_sampling_rates, num_sampling_rates));
    set(gca, 'xticklabel', xticklabels);
    xlabel('Sampling Rate');
    ylabel({strcat('Model Error for ', num2str(i), OrdinalSuffix(i)) ,' most important dimension (%)'});
    saveas(gcf, strcat(prefix, '_model_error_', num2str(i), '.png'));
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
