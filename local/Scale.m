function [ training_set ] = Scale( training_set, original, count )
  [orows, ocols] = size(original);
  scaled = zeros(count * orows, ocols);
  for i = 1:count
    scaled((i-1)*orows+1:i*orows, :) = original + bsxfun(@times, randn(size(original)), mean(original));
  end
  training_set = [training_set; scaled];
end
