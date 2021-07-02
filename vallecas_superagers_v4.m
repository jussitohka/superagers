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
datafn = 'Variables_SA&CO2.0_textformat_edit2.xlsx'; % removed alcoholm amount
for i = 1:3
    [num{i},txt{i},raw{i}]=xlsread(fullfile(datadir,datafn),i);
    rawsz{i} = size(raw{i});
    numsz{i} = size(num{i});
end


if isequal(rawsz{1}(1),rawsz{2}(1),rawsz{3}(1))
    nos = rawsz{1}(1) - 1;
else
    disp('Error:different numbers of subjects in different sheets');
    nos = 0;
end


Y = raw{1}(2:end,3);
for i = 1:nos
    Ynum(i) = strcmp(Y{i},'SA'); % True if superager 
end

    
    
% x sheet 1:
% demographics start 4 
% 1:4 (raw true 4:7, num true 3:6)
% raw always + 3 num always + 2 compared to docx
% gender, handiness, eduyears [1 2 4]
% Xdemo = num{1}(:,[3 4 6]);
% VNdemo = raw{1}(1,[4 5 6]);
% genetics start 8
% 5:7 e2,e4 [6 7]
% Xgene = num{1}(:,[8 9]);
% VN
% social 8:11
% Xsocial = num{1}(:,10:13);
% daily mental use 12:25


% ***************** Sheet 1 ****************************
indset{1} = [3 4]; % corresponding to num 
indname{1} ='Demog'; 
indset{2} = [6];  % drop genetics as non-numeric
indname{2} = 'Education';
indset{3} = [8];
indname{3} = 'Social';
indset{4} = [9]; 
indname{4} = 'DailyMental';
indset{5} = [10:23];
indname{5} = 'Diet';
indset{6} = [24:25];
indname{6} = 'Exercise';
indset{7} = [26:28 30:46]; % lots of missing data 
indname{7} = 'Sleep';
indset{8} = [47:58];
indname{8} ='PEstatus';
% ***************** Sheet 2 ****************************
indset{9} = [1:33]; 
indname{9} = 'MedicalHistory';
indset{10} = [34];
indname{10} = 'Pharmacology';
% ***************** Sheet 3 ****************************
indset{11} = [2 4];
indname{11} = 'Neuropsych without MMSE and Flui';
% ********************************************************
sheetno = [1 1 1 1 1 1 1 1 2 2 3];

% Subject numbers %
for i = 1:3
    for j = 1:nos
        subjno_tmp(j,i) = str2num(raw{i}{j + 1,1});
    end
end
for j = 1:nos
    if ~isequal(subjno_tmp(j,1),subjno_tmp(j,2),subjno_tmp(j,3))
        disp(j)
    end
end

subjno = subjno_tmp(:,1);

nmodalities = length(indname);

for i = 1:nmodalities
    X{i} = num{sheetno(i)}(:,indset{i});
    varName{i} = raw{sheetno(i)}(1,indset{i} + 1);
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


for i = 1:nmodalities
    b = TreeBagger(ntrees,X{i},Ynum,'names',varName{i},'OOBPrediction','on','OOBPredictorImportance','on','PredictorSelection','interaction-curvature')
    yhhat{i} = oobPredict(b);
    imp{i} = b.OOBPermutedPredictorDeltaError;          
end

% the demographics, genetic , and questionnaire data
j = 12;
X{j} = X{1};
varName{j}= varName{1};
for i = 2:8
    X{j} = [X{j} X{i}];
    varName{j} = [varName{j} varName{i}];
end
b = TreeBagger(ntrees,X{j},Ynum,'names',varName{j},'OOBPrediction','on','OOBPredictorImportance','on','PredictorSelection','interaction-curvature')
yhhat{j} = oobPredict(b);
 imp{j} = b.OOBPermutedPredictorDeltaError;     
indname{j} = 'DemoGeneQuestionnaire';

% all but neuropsychiatry 
j = 13;
X{j} = X{1};
varName{j}= varName{1};
for i = 2:10
    X{j} = [X{j} X{i}];
    varName{j} = [varName{j} varName{i}];
end
b = TreeBagger(ntrees,X{j},Ynum,'names',varName{j},'OOBPrediction','on','OOBPredictorImportance','on','PredictorSelection','interaction-curvature')
yhhat{j} = oobPredict(b);
imp{j} = b.OOBPermutedPredictorDeltaError;    
indname{j} = 'All except neuropsych';

j = 14;
X{j} = X{1};
varName{j}= varName{1};
for i = 2:11
    X{j} = [X{j} X{i}];
    varName{j} = [varName{j} varName{i}];
end
% X{j} = [X{j} X{11}(:,[2 4])];
% varName{j} = [varName{j} varName{11}([2 4])];
b = TreeBagger(ntrees,X{j},Ynum,'names',varName{j},'OOBPrediction','on','OOBPredictorImportance','on','PredictorSelection','interaction-curvature')
yhhat{j} = oobPredict(b);
imp{j} = b.OOBPermutedPredictorDeltaError;    
indname{j} = 'All (no MMSE and FLUl)';

save(fullfile(datadir,'tables2_vsuper_v4'),'X','Ynum','indname','subjno','varName')
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


if plotfigs
    for j = 1:length(X)
        figure
        bar(imp{j})
        h = gca;
        set(h,'XTickLabel',varName{j});
        set(h,'XTickLabelRotation', 45)
        set(h,'XTick',1:length(varName{j}));
        title(['OOB Variable Importance:' indname{j}])
        export_fig(fullfile(resultdir,strcat(indname{j},'_varimp.png')),'-r600')
        saveas(gcf,fullfile(resultdir,strcat(indname{j},'_varimp.fig')));
        % save(fullfile(resultdir,'r'),'oober*','imp','pcacomponents');
        close
    end    
end


for j = 1:length(X)
    c = cell2mat(yhhat{j});
    c = str2num(c);
    if length(c) == 119
       [sen(j),spec(j),acc(j),bacc(j)] = senspec(Ynum,c',1);
    else
        idx = find(~isnan(X{j}));
        c2(idx) = c;
        idx = find(isnan(X{j}));
        c2(idx) = round(rand(length(idx),1));
        [sen(j),spec(j),acc(j),bacc(j)] = senspec(Ynum,c2,1);
    end
end

disp(['   | Acc | Sen | Spec']); 
for j = 1:length(X)
      
    disp([indname{j}, ' ', num2str(acc(j)), ' | ',  num2str(sen(j)), ' | ', num2str(spec(j))]);
end
save(fullfile(resultdir,'results151120_xls20_edit2'),'imp','yhhat','indname','varName','Ynum');




