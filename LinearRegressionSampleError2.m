function [ mu, ee, cc ] = LinearRegressionSampleError2( fsample, lsample, params, probability )
  sample_size = size(fsample, 1);
  feature_size = size(fsample, 2);
  %gamma_value = min(eig((fsample.' * fsample) / sample_size)) + lambda;
  weighted_fsample = bsxfun(@times, fsample, fsample * params - lsample);
  cvector = std(weighted_fsample);

  % Yongjoo: a new procedure based on approximation to a second-order form
  C = weighted_fsample' * weighted_fsample / sample_size;     % sample covariance for an error
  H = (1 / sample_size) * fsample' * fsample;
  P = inv(H);               % inverse of Hessian

  mu = params;
  cc = P * C * P';
  ee = sqrt(2 / sample_size) * erfinv((1 - probability)^(1 / feature_size)) * sqrt(diag(cc));

  %epsilon = sqrt(2 / sample_size) * erfinv((1 - probablity)^(1 / feature_size)) * norm(cvector);
end
