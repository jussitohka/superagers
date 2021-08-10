% vallecas_collect_rf_results
clear
v{1} = load('\\research.uefad.uef.fi\workdir\vallecas_superagers\lifestyle_glmnet_results\lifestyle_v6_rf_pvalues_imputed_7500trees.mat');
v{2} = load('\\research.uefad.uef.fi\workdir\vallecas_superagers\lifestyle_glmnet_results\lifestyle_v6_rf_pvalues_imputed_7500trees2.mat');
v{3} = load('\\research.uefad.uef.fi\workdir\vallecas_superagers\lifestyle_glmnet_results\lifestyle_v6_rf_pvalues_imputed_7500trees3.mat');
datadir = 'C:\Users\justoh\Data\vallecas_superagers';
load(fullfile(datadir,'tables4_vsuper_v6'))
data_varname = varName{1};
iter = 500;
clsvec = [v{1}.clsstats.sen,v{1}.clsstats.spec,v{1}.clsstats.acc,v{1}.clsstats.bacc];
% correct p-values to correspond v{1} results. v{2} and v{3}, without permutations, are ignored
for j = 2:3
    v{j}.impstats.p_corr1 = zeros(size(v{1}.imp));
    v{j}.clsstats.p_corr1 = zeros(1,4);
    for i = 1:iter
        pimp = v{j}.impstats.distr(i,:);
        v{j}.impstats.p_corr1 = v{j}.impstats.p_corr1 + double(pimp >= v{1}.imp);
        v{j}.clsstats.p_corr1 = v{j}.clsstats.p_corr1 + double(v{j}.clsstats.distr(i,:) >= clsvec);
    end
end
    
impstats_p = v{1}.impstats.p + (v{2}.impstats.p_corr1)/iter + (v{3}.impstats.p_corr1)/iter;
impstats_p = impstats_p/3;
[~, idx1] = sort(v{1}.impstats.p);
[~, idx] = sort(impstats_p);
% for i = 1:length(idx)
%    disp([num2str(i),':',data_varname{idx1(i)} ':' num2str(v{1}.impstats.p(idx1(i))), ':', num2str(v{1}.imp(idx1(i)))]);
% end
for i = 1:length(idx)
    disp([num2str(i),':',data_varname{idx(i)} ':' num2str(impstats_p(idx(i))), ':', num2str(v{1}.imp(idx(i)))]);
end
pval = impstats_p(idx);
imp = v{1}.imp(idx);
sortedvarname = data_varname(idx);
save(fullfile(datadir,'superagers_rf_imputed_importances_for_marta_table40'),'pval','imp','sortedvarname')
clsstats_p = v{1}.clsstats.p + (v{2}.clsstats.p_corr1)/iter + (v{3}.clsstats.p_corr1)/iter;
clsstats_p = clsstats_p/3;
