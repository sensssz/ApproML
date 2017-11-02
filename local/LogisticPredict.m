function [ predictions ] = LogisticPredict(testset, model)
  predictions = sigmoid(testset * model);
end