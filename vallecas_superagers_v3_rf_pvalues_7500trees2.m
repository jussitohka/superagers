clear
close all
if isunix
   datadir = '/research/work/justoh/vallecas_superagers/lifestyle_glmnet';
    matlabdir = '/research/users/justoh/matlab'; 
    savedir = '/research/work/justoh/vallecas_superagers/lifestyle_glmnet_results';
else
    datadir = 'C:\Users\justoh\Data\vallecas_superagers';
    matlabdir = 'C:\Users\justoh\matlab';
    savedir = 'C:\Users\justoh\Results\vallecas_superagers\lifestyle_glmnet';
    addpath C:\Users\justoh\matlab\spm12\spm12
    addpath C:\Users\justoh\matlab\cat12\cat12
    % imgdir = 'C:\Users\justoh\Data\vallecas_superagers\MRI\filesJussi';
end
addpath(fullfile(matlabdir,'glmnet_matlab2'));
% addpath(fullfile(matlabdir,'libsvm-3.21','matlab'));
addpath(fullfile(matlabdir,'export_fig-master'));
load(fullfile(datadir,'tables2_vsuper_v4'))
alphavec = 0.5;
rng('shuffle')
s = rng;
    
family = 'binomial';
type = 'auc';
opt = glmnetSet;
opt.alpha = alphavec;
% opt.lambda = lambdavec;
y = Ynum';
nfeature_types = 1;

data = X{14}(:,[1 3:size(X{14},2)]); % remove handiness as non numeric
data_varname = varName{14}([1 3:size(X{14},2)]);

idata = knn_imputation_median(data,1:size(data,1),1:size(data,2),0);
savefn = 'lifestyle_rf_pvalues_imputed_7500trees2';
ntrees = 7500; % imputed for imputation, nothing if no imputation 

for k = 1:nfeature_types
    [yhat,imp,impstats,clsstats] = treebagger_variable_importance(ntrees,idata,Ynum,'classification',500);
end
save(fullfile(savedir,savefn),'yhat','imp','impstats','clsstats','s')



