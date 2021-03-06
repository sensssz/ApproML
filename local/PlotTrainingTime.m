function PlotTrainingTime( sampling_rates, training_times, prefix )
  close all;
  num_sampling_rates = size(sampling_rates, 2);
  plot(training_times);
  xticklabels = cell(num_sampling_rates);
  xticklabels = xticklabels(1, :);
  for i = 1:num_sampling_rates
      xticklabels{i} = strcat(num2str(sampling_rates(1, i) * 100), '%');
  end
  set(gca,'FontSize',22);
  set(gca,'XTick',linspace(1, num_sampling_rates, num_sampling_rates));
  set(gca, 'xticklabel', xticklabels);
  xlabel('Sampling Rate');
  ylabel('Training Time (s)');
  figname = strcat(prefix, '_training_time');
  export_fig([figname,'.pdf'], '-pdf','-transparent');
  close all;
end
