function PlotLinearProbErrorBoundSize( probabilities, models, error_bounds, testf )
  num_models = size(models, 2);
  abs_testf = abs(testf);
  error_bound_sizes = zeros(num_models);
  for i = 1:num_models
    model = models(:, i:i);
    error_bound = error_bounds(:, i:i);
    min_prediction = sigmoid(testf * model - abs_testf * error_bound);
    max_prediction = sigmoid(testf * model + abs_testf * error_bound);
    error_bound_sizes(i) = mean(squeeze(max_prediction - min_prediction));
  end

  num_probabilities = size(probabilities, 2);
  plot(error_bound_sizes);
  xticklabels = cell(num_probabilities);
  xticklabels = xticklabels(1, :);
  for i = 1:num_probabilities
    xticklabels{i} = strcat(num2str(probabilities(1, i) * 100), '%');
  end
  set(gca,'FontSize',22);
  set(gca,'XTick',linspace(1, num_probabilities, num_probabilities));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Value of \sigma');
  ylabel({'Size of Error Bound'});
  figname = 'linear_prob_error_bound_size';
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;
end