function PlotPredictionError( sampling_rates, prediction_errors, prefix )
  close(findall(0,'type','figure','name','flashing'));
  num_sampling_rates = size(sampling_rates, 2);
  plot(prediction_errors * 100);
  xticklabels = cell(num_sampling_rates);
  xticklabels = xticklabels(1, :);
  for i = 1:num_sampling_rates
      xticklabels{i} = strcat(num2str(sampling_rates(1, i) * 100), '%');
  end
  set(gca,'XTick',linspace(0, num_sampling_rates, num_sampling_rates));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Sampling Rate');
  ylabel('Prediction Error (%)');
  saveas(gcf, strcat(prefix, '_prediction_error.png'));
end
