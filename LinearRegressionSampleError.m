function [ error_bound ] = LinearRegressionSampleError( fsample, lsample, params, lambda, probability )
  sample_size = size(fsample, 1);
  feature_size = size(fsample, 2);
  weighted_fsample = bsxfun(@times, fsample, fsample * params - lsample);
  cvector = std(weighted_fsample);

  % Yongjoo: a new procedure based on approximation to a second-order form
  sample_covariance = weighted_fsample' * weighted_fsample / sample_size;     % sample covariance for an error
  hessian = (1 / sample_size) * fsample' * fsample;
  inv_heissian = inv(hessian);               % inverse of Hessian
  cc = inv_heissian * sample_covariance * inv_heissian';
  error_bound = sqrt(2 / sample_size) * erfinv((1 - probability)^(1 / feature_size)) * sqrt(diag(cc));
end
