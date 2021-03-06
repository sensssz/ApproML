lambda = 1e-6;
higgs = csvread('~/ApproML/HIGGS-1G.csv');
num_examples = size(higgs, 1);
num_features = size(higgs, 2);
trainf = [higgs(:, 2:num_features) ones(num_examples, 1)];
trainl = higgs(:, 1:1);
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
