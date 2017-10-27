function PlotLogisticErrorBoundSize( sampling_rates, models, error_bounds, testf )
  num_models = size(models, 2);
  num_runs = size(models, 3);
  abs_testf = abs(testf);
  error_bound_sizes = zeros(num_runs, num_models);
  for i = 1:num_runs
    for j = 1:num_models
      model = models(:, j:j, i:i);
      error_bound = error_bounds(:, j:j, i:i);
      min_prediction = sigmoid(testf * model - abs_testf * error_bound);
      max_prediction = sigmoid(testf * model + abs_testf * error_bound);
      error_bound_sizes(i, j) = mean(squeeze(max_prediction - min_prediction));
    end
  end

  num_sampling_rates = size(sampling_rates, 2);
  plot(mean(error_bound_sizes));
  xticklabels = cell(num_sampling_rates);
  xticklabels = xticklabels(1, :);
  for i = 1:num_sampling_rates
    xticklabels{i} = strcat(num2str(sampling_rates(1, i) * 100), '%');
  end
  set(gca,'FontSize',22);
  set(gca,'XTick',linspace(1, num_sampling_rates, num_sampling_rates));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Sampling Rate');
  ylabel({'Size of Error Bound'});
  figname = 'logistic_prediction_error_bound_size';
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;
end