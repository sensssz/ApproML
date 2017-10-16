function [ params, time, gradient_value ] = LogisticRegression( features, labels, lambda )
%LOGISTICREGRESSION Performance logistic regression on the given data
  tic;
  data_size = size(features, 1);
  [ftr_t, nl_t, invl_t, ftr_t_x_lbl] = PreCompute(features, labels);
  function [cost, gradient] = Wrapper(x)
    cost = (nl_t * log(sigmoid(features*x)) - invl_t * log(1 - sigmoid(features*x))) / data_size + lambda*(x.'*x)/2;
    if nargout > 1
      gradient = (ftr_t * sigmoid(features*x) - ftr_t_x_lbl) / data_size + lambda*x;
    end
  end
  options = optimoptions('fminunc','GradObj','on');
  x0 = randn(size(features, 2), 1) * 0.05;
  params = fminunc(@Wrapper, x0, options);
  time = toc;
  gradient_value = (ftr_t * sigmoid(features * params) - ftr_t_x_lbl) / data_size + lambda * params;
end

function [ ftr_t, nl_t, invl_t, ftr_t_x_lbl ] = PreCompute( features, labels )
  ftr_t = features.';
  nl_t = -labels.';
  invl_t = (1 - labels).';
  ftr_t_x_lbl = ftr_t * labels;
end
