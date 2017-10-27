function PlotModelCdf( sampling_rates, original_model, models, prefix )
  close all;
  num_sampling_rates = size(sampling_rates, 2);
  [~, sorted_indices] = sort(abs(original_model), 'descend');
  for i = 1:3
    original_index = sorted_indices(i, 1);
    xvalues = [original_model(original_index, 1); original_model(original_index, 1)];
    yvalues = [0; 1];
    for j = 1:num_sampling_rates
      param_values = models(original_index:original_index, j:j, :);
      cdfplot(param_values);
      hold on;
      plot(xvalues, yvalues);
      title([num2str(i), OrdinalSuffix(i), '-', num2str(sampling_rates(1, j))]);
      figname = strcat(prefix, '_cdf_', num2str(i), OrdinalSuffix(i), '_', num2str(sampling_rates(1, j)));
      export_fig([figname,'.pdf'], '-pdf','-transparent');
      close all;
    end
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
