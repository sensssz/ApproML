function [ params, time, gradient_value ] = LinearRegression( features, labels, lambda )
%LINEARREGRESSION Performance linear regression on the given data
  tic;
  data_size = size(features, 1);
  [ftr_t_x_ftr, ftr_t_x_lbl, lbl_t_x_ftr, lbl_t_x_lbl] = PreCompute(features, labels);
  % w'x'xw - w'x'y - y'xw + y'y
  function [cost, gradient] = Wrapper(x)
    cost = (x.'*ftr_t_x_ftr*x - x.'*ftr_t_x_lbl - lbl_t_x_ftr*x + lbl_t_x_lbl)/(2*data_size) + (lambda/2)*x.'*x;
    if nargout > 1
      gradient = (ftr_t_x_ftr*x - ftr_t_x_lbl) / data_size + lambda*x;
    end
  end
  options = optimoptions('fminunc','GradObj','on');
  x0 = zeros(size(features, 2), 1);
  x0(1, 1) = 1;
  params = fminunc(@Wrapper, x0, options);
  time = toc;
  gradient_value = (ftr_t_x_ftr * params - ftr_t_x_lbl) / data_size + lambda * params;
end

function [ ftr_t_x_ftr, ftr_t_x_lbl, lbl_t_x_ftr, lbl_t_x_lbl ] = PreCompute( features, labels )
  ftr_t = features.';
  lbl_t = labels.';
  ftr_t_x_ftr = ftr_t * features;
  ftr_t_x_lbl = ftr_t * labels;
  lbl_t_x_ftr = lbl_t * features;
  lbl_t_x_lbl = lbl_t * labels;
end
