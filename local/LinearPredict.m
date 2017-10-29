function [ predictions ] = LinearPredict(testset, model)
  predictions = testset * model;
end