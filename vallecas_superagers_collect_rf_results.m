% vallecas_collect_rf_results
clear
v{1} = load('\\research.uefad.uef.fi\workdir\vallecas_superagers\lifestyle_glmnet_results\lifestyle_rf_pvalues_7500trees.mat');
v{2} = load('\\research.uefad.uef.fi\workdir\vallecas_superagers\lifestyle_glmnet_results\lifestyle_rf_pvalues_7500trees2.mat');
v{3} = load('\\research.uefad.uef.fi\workdir\vallecas_superagers\lifestyle_glmnet_results\lifestyle_rf_pvalues_7500trees3.mat');
datadir = 'C:\Users\justoh\Data\vallecas_superagers';
load(fullfile(datadir,'tables2_vsuper_v4'))
data_varname = varName{14}([1 3:size(X{14},2)]);

impstats_p = v{1}.impstats.p + (500*v{2}.impstats.p - 1)/500 + (500*v{3}.impstats.p - 1)/500;
impstats_p = impstats_p/3;
[~, idx1] = sort(v{1}.impstats.p);
[~, idx] = sort(impstats_p);
for i = 1:length(idx)
    disp([num2str(i),':',data_varname{idx1(i)} ':' num2str(v{1}.impstats.p(idx1(i))), ':', num2str(v{1}.imp(idx1(i)))]);
end
for i = 1:length(idx)
    disp([num2str(i),':',data_varname{idx(i)} ':' num2str(impstats_p(idx(i))), ':', num2str(v{1}.imp(idx(i)))]);
end
pval = impstats_p(idx);
imp = v{1}.imp(idx);
sortedvarname = data_varname(idx);
save(fullfile(datadir,'superagers_rf_importances_for_marta'),'pval','imp','sortedvarname')

