function [ predictions ] = LogisticPredict(testset, model)
  predictions = sigmoid(testset * model) > 0.5;
end