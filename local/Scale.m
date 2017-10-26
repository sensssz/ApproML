function [ training_set ] = Scale( training_set, original )
  rand_training = original + bsxfun(@times, randn(size(original)), mean(original));
  training_set = [training_set; rand_training];
end
