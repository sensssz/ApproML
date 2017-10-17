lambda = 1e-6;
dataset = csvread('~/ApproML/HIGGS-1G.csv');
num_examples = size(dataset, 1);
num_features = size(dataset, 2);
trainf = [dataset(:, 1:num_features - 1) ones(num_examples, 1)];
trainl = dataset(:, num_features-1:num_features);
[local_params, local_time, local_gvalue] = LogisticRegression(trainf, trainl, lambda);

%%%%  We get from the environment the number of processors
NP = str2num(getenv('PBS_NP'));

%%%%  Create the pool for parfor to use
thePool = parpool('current', NP);
trainf = distributed(trainf);
trainl = distributed(trainl);
[cluster_params, cluster_time, cluster_gvalue] = LogisticRegressionDistributed(trainf, trainl, lambda);
save('distributed_test_res', 'local_params', 'local_time', 'cluster_params', 'cluster_time');
delete(thePool);
exit
