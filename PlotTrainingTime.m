function PlotTrainingTime( trainf, trainl )
  sampling_rates = [0.01 0.02 0.05 0.08 0.1 0.2 0.5 0.8 1];
  num_sampling_rates = size(sampling_rates, 2);
  linear_training_times = CollectTrainingTimes(@LinearRegressionSample, trainf, trainl, sampling_rates);
  logistic_training_times = CollectTrainingTimes(@LogisticRegressionSample, trainf, trainl, sampling_rates);
  plot(linear_training_times);
  hold on;
  plot(logistic_training_times);

  xticklabels = cell(num_sampling_rates);
  xticklabels = xticklabels(1, :);
  for i = 1:num_sampling_rates
      xticklabels{i} = strcat(num2str(sampling_rates(1, i) * 100), '%');
  end
  set(gca, 'xticklabel', xticklabels);
  xlabel('Sampling Rate');
  ylabel('Training Time (s)');
  legend('Linear Regression', 'Logistic Regression');
  saveas(gcf, 'training_time.png');
end

function [ training_times ] = CollectTrainingTimes( regression, trainf, trainl, sampling_rates )
  num_sampling_rates = size(sampling_rates, 2);
  training_times = zeros(1, num_sampling_rates);
  lambda = 0.01;
  probability = 0.01;
  for i = 1:num_sampling_rates
    sampling_rate = sampling_rates(1, i);
    [~, time, ~, ~, ~] = regression(trainf, trainl, sampling_rate, lambda, probability);
    training_times(1, i) = time;
  end
end
