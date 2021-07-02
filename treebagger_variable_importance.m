% p-values for variable importance based on permutation
% implements the permutation method in
% André Altmann, Laura Tolo?i, Oliver Sander, Thomas Lengauer, 
% Permutation importance: a corrected feature importance measure, 
% Bioinformatics, Volume 26, Issue 10, 15 May 2010, Pages 1340–1347, 
% https://doi.org/10.1093/bioinformatics/btq134
% note that original paper applied this to Gini-importance, but 
% this implementation follows 
% Hapfelmeier, Alexander, and Kurt Ulm. "A new variable selection 
% approach using random forests." Computational Statistics & Data Analysis 60 (2013): 50-69.
% in doing this for permutation importances
% for time being, method must be 'classification'

function [yhat,imp,impstats,clsstats] = treebagger_variable_importance(ntree,X,y,method,iter);

b = TreeBagger(ntree,X,y,'Method',method,'OOBPrediction','on','OOBPredictorImportance','on','PredictorSelection','interaction-curvature');
yhat = oobPredict(b);
imp = b.OOBPermutedPredictorDeltaError;     
c = cell2mat(yhat);
c = str2num(c);
[clsstats.sen,clsstats.spec,clsstats.acc,clsstats.bacc] = senspec(y,c,1);
clsvec = [clsstats.sen,clsstats.spec,clsstats.acc,clsstats.bacc];
impstats.p = ones(size(imp));
clsstats.p = ones(1,4);
clsstats.distr = zeros(iter,4);
impstats.distr = zeros(iter,size(imp,2));
n = length(y);

for i = 1:iter
    disp(i)
    idx = randperm(n);
    yp = y(idx);
    b = TreeBagger(ntree,X,yp,'Method',method,'OOBPrediction','on','OOBPredictorImportance','on','PredictorSelection','interaction-curvature');
    pyhat = oobPredict(b);
    pimp = b.OOBPermutedPredictorDeltaError; 
    impstats.distr(i,:) = pimp;
    impstats.p = impstats.p + double(pimp >= imp);
    c = cell2mat(pyhat);
    c = str2num(c);
    [clsstats.distr(i,1),clsstats.distr(i,2),clsstats.distr(i,3),clsstats.distr(i,4)] = senspec(y,c,1);
    clsstats.p = clsstats.p + double(clsstats.distr(i,:) >= clsvec);
    [clsstats.distr_p(i,1),clsstats.distr_p(i,2),clsstats.distr_p(i,3),clsstats.distr_p(i,4)] = senspec(yp,c,1);
   
end
clsstats.p = clsstats.p/(iter + 1);
impstats.p = impstats.p/(iter + 1);
clsstats.z = norminv(1 - clsstats.p/2); % these are two-sided z-scores corresponding to one-sided p-values
impstats.z = norminv(1 - impstats.p/2); % i.e., the p-values corresponding to these z-values should b multiplied by 2
    
    
    