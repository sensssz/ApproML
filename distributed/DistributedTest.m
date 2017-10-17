lambda = 1e-6;
dataset = csvread('~/ApproML/HIGGS-1G.csv');
num_examples = size(dataset, 1);
num_features = size(dataset, 2);
trainf = [dataset(:, 1:num_features - 1) ones(num_examples, 1)];
trainl = dataset(:, num_features-1:num_features);
[local_params, local_time, local_gvalue] = LogisticRegression(trainf, trainl, lambda);

% This assumes a multinode job
% Set the value for the job storage location
JSL = fullfile(getenv('HOME'), 'matlabdata', getenv('PBS_JOBID'));

% If not inside a PBS job, use 4 processors; assumes you want all
% the processors assigned to the PBS job
if isempty(getenv('PBS_NP'))
    NP = 4;
else
    NP = str2double(getenv('PBS_NP'));
end

% Create the cluster object, set the job storage location, start pool
myCluster = parcluster('current');
myCluster.JobStorageLocation = JSL;
myPool = parpool(myCluster, NP);

trainf = distributed(trainf);
trainl = distributed(trainl);
[cluster_params, cluster_time, cluster_gvalue] = LogisticRegressionDistributed(trainf, trainl, lambda);
save('distributed_test_res', 'local_params', 'local_time', 'cluster_params', 'cluster_time');

delete(myPool);
exit
