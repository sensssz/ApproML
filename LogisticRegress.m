function [ params ] = LinearRegress( features, labels, lambda )
%LINEARREGRESS Performance linear regression on the given data
  tic;
  data_size = size(features, 1);
  [ftr_t, nl_t, invl_t, ftr_t_x_lbl] = PreCompute(features, labels);
  % w'x'xw - w'x'y - y'xw + y'y
  function [cost, gradient] = Wrapper(x)
    cost = (nl_t * log(features*x) - invl_t * log(1 - features*x)) / n + lambda*(x*x.')/2;
    if nargout > 1
      gradient = ftr_t * (Sigmoid(features*x) - labels) / n + lambda*x;
    end
  end
  options = optimoptions('fminunc','GradObj','on');
  x0 = zeros(size(features, 2), 1);
  x0(1, 1) = 1;
  params = fminunc(@Wrapper, x0, options);
  toc;
end

function [ ftr_t, nl_t, invl_t, ftr_t_x_lbl ] = PreCompute( features, labels )
  ftr_t = features.';
  nl_t = -(labels.');
  invl_t = (1 - labels).';
  ftr_t_x_lbl = ftr_t * labels;
end

function [ retval ] = Sigmoid( x )
  retval = 1 / (1 + e^(-x));
end
