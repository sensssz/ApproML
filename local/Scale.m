function [ scaled ] = Scale( training_set )
  rand_training = training_set + bsxfun(@times, randn(size(training_set)), mean(training_set));
  scaled = [training_set; rand_training];
end
