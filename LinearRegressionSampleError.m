function [ epsilon, gamma_value ] = LinearRegressionSampleError( fsample, lsample, params, lambda, probablity )
  sample_size = size(fsample, 1);
  feature_size = size(fsample, 2);
  gamma_value = min(eig((fsample.' * fsample) / sample_size)) + lambda;
  weighted_fsample = bsxfun(@times, fsample, fsample * params - lsample);
  cvector = std(weighted_fsample);
  epsilon = sqrt(2 / sample_size) * erfinv((1 - probablity)^(1 / feature_size)) * norm(cvector);
end
