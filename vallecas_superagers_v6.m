clear
if isunix
    datadir = '';
    matlabdir = '/research/users/justoh/matlab'; 
    resultdir = '';
else
    datadir ='C:\Users\justoh\Data\vallecas_superagers';
    matlabdir = 'C:\Users\justoh\matlab';
    resultdir = 'C:\Users\justoh\Results\vallecas_superagers\rf_without_mmse_and_flui';
end
addpath C:\Users\justoh\matlab\export_fig-master
plotfigs = 0;
ntrees = 7500;
datafn = 'Variables_SA&CO4.0_textformat_nohandiness.xlsx'; % removed alcoholm amount
for i = 1:1
    [num{i},txt{i},raw{i}]=xlsread(fullfile(datadir,datafn),i);
    rawsz{i} = size(raw{i});
    numsz{i} = size(num{i});
end
nos = rawsz{1}(1) - 1;



Y = raw{1}(2:end,2);
for i = 1:nos
    Ynum(i) = strcmp(Y{i},'SA'); % True if superager 
end
% raw = num + 2
    
    

indname{1}  = 'All';
sheetno = [1];
indset{1}= [1:89];
% Subject numbers %
for i = 1:1
    for j = 1:nos
        subjno_tmp(j,i) = str2num(raw{i}{j + 1,1});
    end
end


subjno = subjno_tmp(:,1);

nmodalities = length(indname);

for i = 1:nmodalities
    X{i} = num{sheetno(i)}(:,indset{i});
    varName{i} = raw{sheetno(i)}(1,indset{i} + 2);
end

for i = 1:nmodalities
   idx = find(all(isnan(X{i}')));
   if ~isempty(idx)
       m = nanmedian(X{i});
       for k = 1:length(idx)
           X{i}(idx(k),:) = m;
       end
   end
end

save(fullfile(datadir,'tables4_vsuper_v6'),'X','Ynum','indname','subjno','varName')
% then all the data
% j = 15;
% X{j} = X{1};
% varName{j}= varName{1};
% for i = 2:11
%     X{j} = [X{j} X{i}];
%     varName{j} = [varName{j} varName{i}];
% end
% b = TreeBagger(ntrees,X{j},Ynum,'names',varName{j},'OOBPrediction','on','OOBPredictorImportance','on','PredictorSelection','interaction-curvature')
% yhhat{j} = oobPredict(b);
% imp{j} = b.OOBPermutedPredictorDeltaError;    
% indname{j} = 'All variables';







