function [ error_bound, cc ] = LogisticRegressionSampleError( fsample, lsample, params, lambda, probablity )
  sample_size = size(fsample, 1);
  feature_size = size(fsample, 2);
  sigmoid_data = sigmoid(fsample * params);
  weighted_fsample = bsxfun(@times, fsample, sigmoid_data - lsample);

  % Yongjoo: a new procedure based on approximation to a second-order form
  sample_covariance = weighted_fsample' * weighted_fsample / sample_size;     % sample covariance for an error

  hessian = (1 / sample_size) * fsample' ...
            * bsxfun(@times, fsample, sigmoid_data * (1 - sigmod_data)) ...
            + lambda * eye(feature_size);
  inv_hessian = inv(hessian);                                                 % inverse of Hessian
  cc = inv_hessian * sample_covariance * inv_hessian';
  error_bound = sqrt(2 / sample_size) * erfinv((1 - probability)^(1 / feature_size)) * sqrt(diag(cc));
end
