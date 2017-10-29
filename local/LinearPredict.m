function [ predictions ] = LinearPredict(model, testset)
  predictions = testset * model;
end