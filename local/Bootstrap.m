function [ params, sampling_times, training_times, model_error_bounds, prediction_error_bounds ] = Bootstrap( original_model, sampling_rates, lambda, regression, predict, trainf, trainl, testf, testl, prefix )
  num_sampling_rates = size(sampling_rates, 2);
  num_examples = size(trainf, 1);
  num_features = size(trainf, 2);
  params = zeros(num_features, num_sampling_rates);
  sampling_times = zeros(1, num_sampling_rates);
  training_times = zeros(1, num_sampling_rates);
  model_error_bounds = zeros(num_features, 2, num_sampling_rates);
  prediction_error_bounds = zeros(num_features, 2, num_sampling_rates);
  for i = 1:num_sampling_rates
    sample_rate = sampling_rates(1, i);
    sample_size = int32(num_examples * sample_rate);
    rand_perm = randperm(num_examples, sample_size);
    fsample = trainf(rand_perm, :);
    lsample = trainl(rand_perm, :);
    [ param, training_time, model_error, prediction_error ] = BootstrapTrain(regression, predict, fsample, lsample, testf, lambda);
    params(:, i:i) = param;
    training_times(:, i:i) = training_time;
    model_error_bounds(:, :, i:i) = model_error;
    prediction_error_bounds(:, :, i:i) = prediction_error;
  end

  PlotTrainingTime(sampling_rates, training_times, prefix);
  original_prediction = predict(original_model, testf);
  PlotModelBoundingProbabilities(original_model, sampling_rates, model_error_bounds, prefix);
  PlotPredictionBoundingProbabilities(original_prediction, sampling_rates, preidction_error_bounds, prefix);
end

function [ mean_param, training_time, model_error_bound, prediction_error_bound ] = BootstrapTrain( regression, predict, trainf, trainl, testf, lambda )
  tic;
  num_samples = size(trainf, 1);
  num_features = size(trainf, 2);
  num_tests = size(testf, 1);
  num_runs = 1;
  params = zeros(num_features, num_runs);
  predictions = zeros(num_tests, num_runs);
  for i = 1:num_runs
    fsample = datasample(trainf, num_samples);
    lsample = datasample(trainl, num_samples);
    [ param, ~, ~ ] = regression(fsample, lsample, lambda);
    params(:, i:i) = param;
    predictions(:, i:i) = predict(testf, param);
  end
  training_time = toc;
  mean_param = mean(params, 2);
  model_error_bound = [ prctile(params, 1, 2) prctile(params, 99, 2) ];
  prediction_error_bound = [ prctile(predictions, 1, 2) prctile(predictions, 99, 2) ];
end

function PlotModelBoundingProbabilities( original_model, sampling_rates, model_error_bounds, prefix )
  num_models = size(model_error_bounds, 3);
  bounding_probabilities = zeros(1, num_models);
  for i = 1:num_models
    error_bound = model_error_bounds(:, :, i:i);
    min_model = error_bound(:, 1:1);
    max_model = error_bound(:, 2:2);
    if sum(min_model > original_model) == 0 && sum(max_model < original_model) == 0
      bounding_probabilities(1, i) = bounding_probabilities(1, i) + 1;
    end
  end

  num_sampling_rates = size(sampling_rates, 2);
  plot(bounding_probabilities * 100 / num_runs);
  xticklabels = cell(num_sampling_rates);
  xticklabels = xticklabels(1, :);
  for i = 1:num_sampling_rates
      xticklabels{i} = strcat(num2str(sampling_rates(1, i) * 100), '%');
  end
  set(gca,'FontSize',22);
  set(gca,'XTick',linspace(1, num_sampling_rates, num_sampling_rates));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Sampling Rate');
  ylabel({'Probability of Error Bound', 'Holding for Bootstrap Model (%)'});
  figname = strcat(prefix, '_bootstrap_model_error_bound');
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;
end

function PlotPredictionBoundingProbabilities( original_prediction, sampling_rates, prediction_error_bounds, prefix )
  num_sampling_rates = size(sampling_rates, 3);
  bounding_probabilities = zeros(1, num_sampling_rates);
  num_predictions = size(original_prediction, 1);
  for i = 1:num_sampling_rates
    error_bound = prediction_error_bounds(:, :, i:i);
    min_prediction = error_bound(:, 1:1);
    max_prediction = error_bound(:, 2:2);
    success = sum(min_prediction <= original_prediction & max_prediction >= original_prediction);
    bounding_probabilities(1, i) = success / num_predictions;
  end

  plot(bounding_probabilities * 100 / num_runs);
  xticklabels = cell(num_sampling_rates);
  xticklabels = xticklabels(1, :);
  for i = 1:num_sampling_rates
      xticklabels{i} = strcat(num2str(sampling_rates(1, i) * 100), '%');
  end
  set(gca,'FontSize',22);
  set(gca,'XTick',linspace(1, num_sampling_rates, num_sampling_rates));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Sampling Rate');
  ylabel({'Probability of Error Bound', 'Holding for Bootstrap Model (%)'});
  figname = strcat(prefix, '_bootstrap_prediction_error_bound');
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;
end
