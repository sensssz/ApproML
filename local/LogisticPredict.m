function [ predictions ] = LogisticPredict(model, testset)
  predictions = sigmoid(testset * model) > 0.5;
end