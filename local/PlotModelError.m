function PlotTrainingTime( sampling_rates, original_model, model_errors, prefix )
  close(findall(0,'type','figure','name','flashing'));
  num_sampling_rates = size(sampling_rates, 2);
  [~, sorted_indices] = sort(abs(original_model), 'descend');
  for i = 1:3
    original_index = sorted_indices(i, 1);
    plot(model_errors(original_index:original_index, :));
    xticklabels = cell(num_sampling_rates);
    xticklabels = xticklabels(1, :);
    for j = 1:num_sampling_rates
        xticklabels{j} = strcat(num2str(sampling_rates(1, j) * 100), '%');
    end
    set(gca, 'xticklabel', xticklabels);
    xlabel('Sampling Rate');
    ylabel(['Model Error for ', num2str(i), OrdinalSuffix(i) ,' most important dimension (%)']);
    saveas(gcf, strcat(prefix, '_model_error_', num2str(i), '.png'));
    close(findall(0,'type','figure','name','flashing'));
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
