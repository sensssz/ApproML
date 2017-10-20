function PlotPredictionError( sampling_rates, prediction_errors, against, prefix )
  num_sampling_rates = size(sampling_rates, 2);
  xaxis = (1:num_sampling_rates)';
  min_errors = min(prediction_errors, [], 3);
  avg_errors = mean(prediction_errors, 3);
  max_errors = max(prediction_errors, [], 3);
  bound_patch = patch([xaxis; xaxis(end:-1:1); xaxis(1)], [min_errors; max_errors(end:-1:1); min_errors(1)], 'r');
  hold on;
  error_line = line(xaxis, avg_errors);
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
  ylabel(['Prediction Error Against ', against ,' (%)']);
  saveas(gcf, strcat(prefix, '_prediction_error.png'));
  close all;
end
