%LDA (Allen): PD vs Stroke   
%November 5, 2020

%% 01: MC connection only

%1 connection (mc), 1/4 phases, 1/7 time points
load('D:\MEG-DBS\analysis\ANALYSIS_2018\Allen_LDA_PDvsStroke\Beta Coherence_allChannels.mat');
group = reshape(coh.dx,[],1);   %1x12 to 12x1
phase = {'rest','hold','prep','move'};

mat_classifiers = [0 0 0 0 0 0 0];   %phase(1-4), timepoint(1-7), #NaNs, #obs, resub error, test/gen error, accuracy
for ph=1:4;   %phase: rest, hold, prep, move
    phase2 = phase{ph};
    for t=1:7;   %time point: baseline (prestim), 5 min into stim, 15 min into stim, stim off now/post stim 0 min, post stim 5 min, post stim 10 min, post stim 15 min
        coh2 = eval(['coh.' phase2 '.mc{t,1}']);   %1x1x12 to 12x1
        coh3 = permute(coh2,[3 1 2]);
        indices_NaN = find(isnan(coh3)==1);
        N_NaN = size(indices_NaN,1);
        N_obs = size(coh3,1)-N_NaN;
        coh3_NaNrmv = coh3;
        coh3_NaNrmv(indices_NaN)=[];
        group_NaNrmv = group;
        group_NaNrmv(indices_NaN)=[];
    
        if N_NaN==size(coh3,1);   %all NaN, add empty row to classifier
            mat_classifiers = cat(1,mat_classifiers,[ph t N_NaN N_obs NaN NaN NaN]);   %phase(1-4), timepoint(1-7), #NaNs, #obs, resub error, test/gen error, accuracy
        elseif ph==2 & t==4;   %phase/time combo with too many NaNs
            mat_classifiers = cat(1,mat_classifiers,[ph t N_NaN N_obs NaN NaN NaN]);   %phase(1-4), timepoint(1-7), #NaNs, #obs, resub error, test/gen error, accuracy
        elseif ph==3 & t==4;   %phase/time combo with too many NaNs
            mat_classifiers = cat(1,mat_classifiers,[ph t N_NaN N_obs NaN NaN NaN]);   %phase(1-4), timepoint(1-7), #NaNs, #obs, resub error, test/gen error, accuracy
        elseif ph==4 & t==4;   %phase/time combo with too many NaNs
            mat_classifiers = cat(1,mat_classifiers,[ph t N_NaN N_obs NaN NaN NaN]);   %phase(1-4), timepoint(1-7), #NaNs, #obs, resub error, test/gen error, accuracy
        else
            lda = fitcdiscr(coh3_NaNrmv,group_NaNrmv);   %LDA
    %         lda = fitcsvm(coh,group);   %SVM
            ldaClass = resubPredict(lda);

            %resubstitution error: misclassification error (the proportion of misclassified observations) on the training set
            ldaResubErr = resubLoss(lda);

            %test/generalization error: expected prediction error on an independent set (resubstitution error will likely under-estimate the test error)
            %without a validation or another labeled 'testing' data set, you can simulate one by doing cross-validation
            %use a stratified 10-fold cross-validation to estimate test error on classification algorithms
            %it randomly divides the training set into 10 disjoint subsets
            %each subset has roughly equal size and roughly the same class proportions as in the training set
            %remove one subset, train the classification model using the other nine subsets, and use the trained model to classify the removed subset
            %you could repeat this by removing each of the ten subsets one at a time

            rng(0,'twister');   %random number generator

            %generate 5(10) disjoint stratified subsets
            cp = cvpartition(group_NaNrmv,'KFold',5);   %5 subsets for 12 subjects. Max is 3 test, 9 train (25%/75%), min depends on #NaNs.

            %estimate the true test error for LDA using 5(10)-fold stratified cross-validation.
            cvlda = crossval(lda,'CVPartition',cp);
            ldaCVErr = kfoldLoss(cvlda);

            %add classifier results to classifier matrix
            mat_classifiers = cat(1,mat_classifiers,[ph t N_NaN N_obs ldaResubErr*100 ldaCVErr*100 (1-ldaCVErr)*100]);   %phase(1-4), timepoint(1-7), #NaNs, #obs, resub error, test/gen error, accuracy
        end    
    end
end

%remove empty first row
mat_classifiers2 = mat_classifiers(2:end,:);

%matrix to table, excel spreadsheet
table_classifiers = table(mat_classifiers2(:,1),mat_classifiers2(:,2),mat_classifiers2(:,3),mat_classifiers2(:,4),mat_classifiers2(:,5),mat_classifiers2(:,6),mat_classifiers2(:,7));
table_classifiers.Properties.VariableNames{1} = 'Phase';
table_classifiers.Properties.VariableNames{2} = 'Timepoint';
table_classifiers.Properties.VariableNames{3} = 'N_NaNs';
table_classifiers.Properties.VariableNames{4} = 'N_Obs';
table_classifiers.Properties.VariableNames{5} = 'Resub_error';
table_classifiers.Properties.VariableNames{6} = 'TestGen_error';
table_classifiers.Properties.VariableNames{7} = 'Accuracy';

filename = ['01_PDvsStroke_N12obs_N1connMC.xlsx'];
cd('D:\MEG-DBS\analysis\ANALYSIS_2018\Allen_LDA_PDvsStroke');
writetable(table_classifiers,filename);

% Connect to Excel
Excel = actxserver('excel.application');
% Get Workbook object
WB = Excel.Workbooks.Open(fullfile(pwd,filename),0,false);   
% Save Workbook
WB.Save();
% Close Workbook
WB.Close();
% Quit Excel
Excel.Quit();
        
        
%% 02: Total connectivity only

%1 connection (total value), 1/4 phases, 1/7 time points
load('D:\MEG-DBS\analysis\ANALYSIS_2018\Allen_LDA_PDvsStroke\Beta Coherence_allChannels.mat');
group = reshape(coh.dx,[],1);   %1x12 to 12x1
phase = {'rest','hold','prep','move'};

mat_classifiers = [0 0 0 0 0 0 0];   %phase(1-4), timepoint(1-7), #NaNs, #obs, resub error, test/gen error, accuracy
for ph=1:4;   %phase: rest, hold, prep, move
    phase2 = phase{ph};
    for t=1:7;   %time point: baseline (prestim), 5 min into stim, 15 min into stim, stim off now/post stim 0 min, post stim 5 min, post stim 10 min, post stim 15 min
        coh2 = eval(['coh.' phase2 '.total{t,1}']);   %1x1x12 to 12x1
        coh3 = permute(coh2,[3 1 2]);
        indices_NaN = find(isnan(coh3)==1);
        N_NaN = size(indices_NaN,1);
        N_obs = size(coh3,1)-N_NaN;
        coh3_NaNrmv = coh3;
        coh3_NaNrmv(indices_NaN)=[];
        group_NaNrmv = group;
        group_NaNrmv(indices_NaN)=[];
    
        if N_NaN==size(coh3,1);   %all NaN, add empty row to classifier
            mat_classifiers = cat(1,mat_classifiers,[ph t N_NaN N_obs NaN NaN NaN]);   %phase(1-4), timepoint(1-7), #NaNs, #obs, resub error, test/gen error, accuracy
        elseif ph==2 & t==4;   %phase/time combo with too many NaNs
            mat_classifiers = cat(1,mat_classifiers,[ph t N_NaN N_obs NaN NaN NaN]);   %phase(1-4), timepoint(1-7), #NaNs, #obs, resub error, test/gen error, accuracy
        elseif ph==3 & t==4;   %phase/time combo with too many NaNs
            mat_classifiers = cat(1,mat_classifiers,[ph t N_NaN N_obs NaN NaN NaN]);   %phase(1-4), timepoint(1-7), #NaNs, #obs, resub error, test/gen error, accuracy
        elseif ph==4 & t==4;   %phase/time combo with too many NaNs
            mat_classifiers = cat(1,mat_classifiers,[ph t N_NaN N_obs NaN NaN NaN]);   %phase(1-4), timepoint(1-7), #NaNs, #obs, resub error, test/gen error, accuracy
        else
            lda = fitcdiscr(coh3_NaNrmv,group_NaNrmv);   %LDA
    %         lda = fitcsvm(coh,group);   %SVM
            ldaClass = resubPredict(lda);

            %resubstitution error: misclassification error (the proportion of misclassified observations) on the training set
            ldaResubErr = resubLoss(lda);

            %test/generalization error: expected prediction error on an independent set (resubstitution error will likely under-estimate the test error)
            %without a validation or another labeled 'testing' data set, you can simulate one by doing cross-validation
            %use a stratified 10-fold cross-validation to estimate test error on classification algorithms
            %it randomly divides the training set into 10 disjoint subsets
            %each subset has roughly equal size and roughly the same class proportions as in the training set
            %remove one subset, train the classification model using the other nine subsets, and use the trained model to classify the removed subset
            %you could repeat this by removing each of the ten subsets one at a time

            rng(0,'twister');   %random number generator

            %generate 5(10) disjoint stratified subsets
            cp = cvpartition(group_NaNrmv,'KFold',5);   %5 subsets for 12 subjects. Max is 3 test, 9 train (25%/75%), min depends on #NaNs.

            %estimate the true test error for LDA using 5(10)-fold stratified cross-validation.
            cvlda = crossval(lda,'CVPartition',cp);
            ldaCVErr = kfoldLoss(cvlda);

            %add classifier results to classifier matrix
            mat_classifiers = cat(1,mat_classifiers,[ph t N_NaN N_obs ldaResubErr*100 ldaCVErr*100 (1-ldaCVErr)*100]);   %phase(1-4), timepoint(1-7), #NaNs, #obs, resub error, test/gen error, accuracy
        end    
    end
end

%remove empty first row
mat_classifiers2 = mat_classifiers(2:end,:);

%matrix to table, excel spreadsheet
table_classifiers = table(mat_classifiers2(:,1),mat_classifiers2(:,2),mat_classifiers2(:,3),mat_classifiers2(:,4),mat_classifiers2(:,5),mat_classifiers2(:,6),mat_classifiers2(:,7));
table_classifiers.Properties.VariableNames{1} = 'Phase';
table_classifiers.Properties.VariableNames{2} = 'Timepoint';
table_classifiers.Properties.VariableNames{3} = 'N_NaNs';
table_classifiers.Properties.VariableNames{4} = 'N_Obs';
table_classifiers.Properties.VariableNames{5} = 'Resub_error';
table_classifiers.Properties.VariableNames{6} = 'TestGen_error';
table_classifiers.Properties.VariableNames{7} = 'Accuracy';

filename = ['02_PDvsStroke_N12obs_N1connTotal.xlsx'];
cd('D:\MEG-DBS\analysis\ANALYSIS_2018\Allen_LDA_PDvsStroke');
writetable(table_classifiers,filename);

% Connect to Excel
Excel = actxserver('excel.application');
% Get Workbook object
WB = Excel.Workbooks.Open(fullfile(pwd,filename),0,false);   
% Save Workbook
WB.Save();
% Close Workbook
WB.Close();
% Quit Excel
Excel.Quit();


%% 03: MC coh, use 7 time points as features in LDA ? 7 dimensional 

%1 connection (mc), 1/4 phases
%7 time points as LDA input features
load('D:\MEG-DBS\analysis\ANALYSIS_2018\Allen_LDA_PDvsStroke\Beta Coherence_allChannels.mat');
group = reshape(coh.dx,[],1);   %1x12 to 12x1
phase = {'rest','rest','hold','hold','prep','prep','move','move'};   %2nd rest for diff. #timepoint predictors
phase_num = [1 1 2 2 3 3 4 4];

mat_classifiers = [0 0 0 0 0 0 0];   %phase(1-4), #timepoint features, #NaNs, #obs, resub error, test/gen error, accuracy
for ph=1:size(phase,2);   %phase: rest, hold, prep, move
    phase2 = phase{ph};
    for t=1:7;   %time point: baseline (prestim), 5 min into stim, 15 min into stim, stim off now/post stim 0 min, post stim 5 min, post stim 10 min, post stim 15 min
        coh2(:,t) = eval(['coh.' phase2 '.mc{t,1}']);   %1x1x12 to 12x1 to 12x7 (end of forloop)
    end
    
    %remove column if too many NaNs - manually check
    coh3 = coh2;
    if ph==1;   %rest1
        t=[4 6];   
        coh3(:,t)=[];
    elseif ph==2;   %rest2
        t=[4 6 7];
        coh3(:,t)=[];
    elseif ph==3;   %hold1
        t=[4 6];
        coh3(:,t)=[];
    elseif ph==4;   %hold2
        t=[4 6 7];
        coh3(:,t)=[];
    elseif ph==5;   %prep1
        t=[4 6];
        coh3(:,t)=[];
    elseif ph==6;   %prep2
        t=[4 6 7];
        coh3(:,t)=[];
    elseif ph==7;   %move1
        t=[4 6];
        coh3(:,t)=[];
    elseif ph==8;   %move2
        t=[4 6 7];
        coh3(:,t)=[];
    end
    N_col = size(coh3,2);
    
    %remove rows with any NaNs and count remaining subjects
        indices_NaN = any(isnan(coh3),2);
        indices_NaN = find(any(isnan(coh3),2)==1);
        N_NaN = size(indices_NaN,1);
        N_obs = size(coh3,1)-N_NaN;
        coh3_NaNrmv = coh3;
        coh3_NaNrmv(indices_NaN,:)=[];
        group_NaNrmv = group;
        group_NaNrmv(indices_NaN)=[];
    
            lda = fitcdiscr(coh3_NaNrmv,group_NaNrmv);   %LDA
    %         lda = fitcsvm(coh,group);   %SVM
            ldaClass = resubPredict(lda);

            %resubstitution error: misclassification error (the proportion of misclassified observations) on the training set
            ldaResubErr = resubLoss(lda);

            %test/generalization error: expected prediction error on an independent set (resubstitution error will likely under-estimate the test error)
            %without a validation or another labeled 'testing' data set, you can simulate one by doing cross-validation
            %use a stratified 10-fold cross-validation to estimate test error on classification algorithms
            %it randomly divides the training set into 10 disjoint subsets
            %each subset has roughly equal size and roughly the same class proportions as in the training set
            %remove one subset, train the classification model using the other nine subsets, and use the trained model to classify the removed subset
            %you could repeat this by removing each of the ten subsets one at a time

            rng(0,'twister');   %random number generator

            %generate 5(10) disjoint stratified subsets
            cp = cvpartition(group_NaNrmv,'KFold',5);   %5 subsets for 12 subjects. Max is 3 test, 9 train (25%/75%), min depends on #NaNs.

            %estimate the true test error for LDA using 5(10)-fold stratified cross-validation.
            cvlda = crossval(lda,'CVPartition',cp);
            ldaCVErr = kfoldLoss(cvlda);

            %add classifier results to classifier matrix
            mat_classifiers = cat(1,mat_classifiers,[phase_num(ph) N_col N_NaN N_obs ldaResubErr*100 ldaCVErr*100 (1-ldaCVErr)*100]);   %phase(1-4), #timepoint features, #NaNs, #obs, resub error, test/gen error, accuracy
end    

%remove empty first row
mat_classifiers2 = mat_classifiers(2:end,:);

%matrix to table, excel spreadsheet
table_classifiers = table(mat_classifiers2(:,1),mat_classifiers2(:,2),mat_classifiers2(:,3),mat_classifiers2(:,4),mat_classifiers2(:,5),mat_classifiers2(:,6),mat_classifiers2(:,7));
table_classifiers.Properties.VariableNames{1} = 'Phase';
table_classifiers.Properties.VariableNames{2} = 'N_Timepoints_asPredictors';
table_classifiers.Properties.VariableNames{3} = 'N_NaNs';
table_classifiers.Properties.VariableNames{4} = 'N_Obs';
table_classifiers.Properties.VariableNames{5} = 'Resub_error';
table_classifiers.Properties.VariableNames{6} = 'TestGen_error';
table_classifiers.Properties.VariableNames{7} = 'Accuracy';

filename = ['03_PDvsStroke_N12obs_N1connMC_7Dtimepoints.xlsx'];
cd('D:\MEG-DBS\analysis\ANALYSIS_2018\Allen_LDA_PDvsStroke');
writetable(table_classifiers,filename);

% Connect to Excel
Excel = actxserver('excel.application');
% Get Workbook object
WB = Excel.Workbooks.Open(fullfile(pwd,filename),0,false);   
% Save Workbook
WB.Save();
% Close Workbook
WB.Close();
% Quit Excel
Excel.Quit();


%% 04: Total coh, use 7 time points as features in LDA ? 7 dimensional 

%1 connection (total), 1/4 phases
%7 time points as LDA input features
load('D:\MEG-DBS\analysis\ANALYSIS_2018\Allen_LDA_PDvsStroke\Beta Coherence_allChannels.mat');
group = reshape(coh.dx,[],1);   %1x12 to 12x1
phase = {'rest','rest','hold','hold','prep','prep','move','move'};   %2nd rest for diff. #timepoint predictors
phase_num = [1 1 2 2 3 3 4 4];

mat_classifiers = [0 0 0 0 0 0 0];   %phase(1-4), #timepoint features, #NaNs, #obs, resub error, test/gen error, accuracy
for ph=1:size(phase,2);   %phase: rest, hold, prep, move
    phase2 = phase{ph};
    for t=1:7;   %time point: baseline (prestim), 5 min into stim, 15 min into stim, stim off now/post stim 0 min, post stim 5 min, post stim 10 min, post stim 15 min
        coh2(:,t) = eval(['coh.' phase2 '.total{t,1}']);   %1x1x12 to 12x1 to 12x7 (end of forloop)
    end
    
    %remove column if too many NaNs - manually check
    coh3 = coh2;
    if ph==1;   %rest1
        t=[4 6];   
        coh3(:,t)=[];
    elseif ph==2;   %rest2
        t=[4 6 7];
        coh3(:,t)=[];
    elseif ph==3;   %hold1
        t=[4 6];
        coh3(:,t)=[];
    elseif ph==4;   %hold2
        t=[4 6 7];
        coh3(:,t)=[];
    elseif ph==5;   %prep1
        t=[4 6];
        coh3(:,t)=[];
    elseif ph==6;   %prep2
        t=[4 6 7];
        coh3(:,t)=[];
    elseif ph==7;   %move1
        t=[4 6];
        coh3(:,t)=[];
    elseif ph==8;   %move2
        t=[4 6 7];
        coh3(:,t)=[];
    end
    N_col = size(coh3,2);
    
    %remove rows with any NaNs and count remaining subjects
        indices_NaN = any(isnan(coh3),2);
        indices_NaN = find(any(isnan(coh3),2)==1);
        N_NaN = size(indices_NaN,1);
        N_obs = size(coh3,1)-N_NaN;
        coh3_NaNrmv = coh3;
        coh3_NaNrmv(indices_NaN,:)=[];
        group_NaNrmv = group;
        group_NaNrmv(indices_NaN)=[];
    
            lda = fitcdiscr(coh3_NaNrmv,group_NaNrmv);   %LDA
    %         lda = fitcsvm(coh,group);   %SVM
            ldaClass = resubPredict(lda);

            %resubstitution error: misclassification error (the proportion of misclassified observations) on the training set
            ldaResubErr = resubLoss(lda);

            %test/generalization error: expected prediction error on an independent set (resubstitution error will likely under-estimate the test error)
            %without a validation or another labeled 'testing' data set, you can simulate one by doing cross-validation
            %use a stratified 10-fold cross-validation to estimate test error on classification algorithms
            %it randomly divides the training set into 10 disjoint subsets
            %each subset has roughly equal size and roughly the same class proportions as in the training set
            %remove one subset, train the classification model using the other nine subsets, and use the trained model to classify the removed subset
            %you could repeat this by removing each of the ten subsets one at a time

            rng(0,'twister');   %random number generator

            %generate 5(10) disjoint stratified subsets
            cp = cvpartition(group_NaNrmv,'KFold',5);   %5 subsets for 12 subjects. Max is 3 test, 9 train (25%/75%), min depends on #NaNs.

            %estimate the true test error for LDA using 5(10)-fold stratified cross-validation.
            cvlda = crossval(lda,'CVPartition',cp);
            ldaCVErr = kfoldLoss(cvlda);

            %add classifier results to classifier matrix
            mat_classifiers = cat(1,mat_classifiers,[phase_num(ph) N_col N_NaN N_obs ldaResubErr*100 ldaCVErr*100 (1-ldaCVErr)*100]);   %phase(1-4), #timepoint features, #NaNs, #obs, resub error, test/gen error, accuracy
end    


%remove empty first row
mat_classifiers2 = mat_classifiers(2:end,:);

%matrix to table, excel spreadsheet
table_classifiers = table(mat_classifiers2(:,1),mat_classifiers2(:,2),mat_classifiers2(:,3),mat_classifiers2(:,4),mat_classifiers2(:,5),mat_classifiers2(:,6),mat_classifiers2(:,7));
table_classifiers.Properties.VariableNames{1} = 'Phase';
table_classifiers.Properties.VariableNames{2} = 'N_Timepoints_asPredictors';
table_classifiers.Properties.VariableNames{3} = 'N_NaNs';
table_classifiers.Properties.VariableNames{4} = 'N_Obs';
table_classifiers.Properties.VariableNames{5} = 'Resub_error';
table_classifiers.Properties.VariableNames{6} = 'TestGen_error';
table_classifiers.Properties.VariableNames{7} = 'Accuracy';

filename = ['04_PDvsStroke_N12obs_N1connTotal_7Dtimepoints.xlsx'];
cd('D:\MEG-DBS\analysis\ANALYSIS_2018\Allen_LDA_PDvsStroke');
writetable(table_classifiers,filename);

% Connect to Excel
Excel = actxserver('excel.application');
% Get Workbook object
WB = Excel.Workbooks.Open(fullfile(pwd,filename),0,false);   
% Save Workbook
WB.Save();
% Close Workbook
WB.Close();
% Quit Excel
Excel.Quit();


%% 05: MC coh, use 4 phases as features in LDA ? 4 dimensional 

%1 connection (mc), 1/7 time points
%4 phases as LDA input features
load('D:\MEG-DBS\analysis\ANALYSIS_2018\Allen_LDA_PDvsStroke\Beta Coherence_allChannels.mat');
group = reshape(coh.dx,[],1);   %1x12 to 12x1
phase = {'rest','hold','prep','move'};   %2nd rest for diff. #timepoint predictors

mat_classifiers = [0 0 0 0 0 0 0];   %phase(1-4), #timepoint features, #NaNs, #obs, resub error, test/gen error, accuracy
for t=[1:3 5:7];   %time point: baseline (prestim), 5 min into stim, 15 min into stim, stim off now/post stim 0 min, post stim 5 min, post stim 10 min, post stim 15 min
    for ph=1:size(phase,2);   %phase: rest, hold, prep, move
        phase2 = phase{ph};
        coh2(:,ph) = eval(['coh.' phase2 '.mc{t,1}']);   %1x1x12 to 12x1 to 12x4 (end of forloop)
    end
    
    %remove column if too many NaNs - manually check
    coh3 = coh2;
    if t==1;   %timepoint1
        ph=[];   
        coh3(:,ph)=[];
    elseif t==2;   %timepoint2
        ph=[];
        coh3(:,ph)=[];
    elseif t==3;   %timepoint3
        ph=[];
        coh3(:,ph)=[];
    %timepoint4 removed at level of forloop    
    elseif t==5;   %timepoint5
        ph=[];
        coh3(:,ph)=[];
    elseif t==6;   %timepoint6
        ph=[];
        coh3(:,ph)=[]; 
    elseif t==7;   %timepoint7
        ph=[];
        coh3(:,ph)=[]; 
    end
    N_col = size(coh3,2);
    
    %remove rows with any NaNs and count remaining subjects
        indices_NaN = any(isnan(coh3),2);
        indices_NaN = find(any(isnan(coh3),2)==1);
        N_NaN = size(indices_NaN,1);
        N_obs = size(coh3,1)-N_NaN;
        coh3_NaNrmv = coh3;
        coh3_NaNrmv(indices_NaN,:)=[];
        group_NaNrmv = group;
        group_NaNrmv(indices_NaN)=[];
    
            lda = fitcdiscr(coh3_NaNrmv,group_NaNrmv);   %LDA
    %         lda = fitcsvm(coh,group);   %SVM
            ldaClass = resubPredict(lda);

            %resubstitution error: misclassification error (the proportion of misclassified observations) on the training set
            ldaResubErr = resubLoss(lda);

            %test/generalization error: expected prediction error on an independent set (resubstitution error will likely under-estimate the test error)
            %without a validation or another labeled 'testing' data set, you can simulate one by doing cross-validation
            %use a stratified 10-fold cross-validation to estimate test error on classification algorithms
            %it randomly divides the training set into 10 disjoint subsets
            %each subset has roughly equal size and roughly the same class proportions as in the training set
            %remove one subset, train the classification model using the other nine subsets, and use the trained model to classify the removed subset
            %you could repeat this by removing each of the ten subsets one at a time

            rng(0,'twister');   %random number generator

            %generate 5(10) disjoint stratified subsets
            cp = cvpartition(group_NaNrmv,'KFold',5);   %5 subsets for 12 subjects. Max is 3 test, 9 train (25%/75%), min depends on #NaNs.

            %estimate the true test error for LDA using 5(10)-fold stratified cross-validation.
            cvlda = crossval(lda,'CVPartition',cp);
            ldaCVErr = kfoldLoss(cvlda);

            %add classifier results to classifier matrix
            mat_classifiers = cat(1,mat_classifiers,[t N_col N_NaN N_obs ldaResubErr*100 ldaCVErr*100 (1-ldaCVErr)*100]);   %phase(1-4), #timepoint features, #NaNs, #obs, resub error, test/gen error, accuracy
end    


%remove empty first row
mat_classifiers2 = mat_classifiers(2:end,:);

%matrix to table, excel spreadsheet
table_classifiers = table(mat_classifiers2(:,1),mat_classifiers2(:,2),mat_classifiers2(:,3),mat_classifiers2(:,4),mat_classifiers2(:,5),mat_classifiers2(:,6),mat_classifiers2(:,7));
table_classifiers.Properties.VariableNames{1} = 'Timepoint';
table_classifiers.Properties.VariableNames{2} = 'N_Phases_asPredictors';
table_classifiers.Properties.VariableNames{3} = 'N_NaNs';
table_classifiers.Properties.VariableNames{4} = 'N_Obs';
table_classifiers.Properties.VariableNames{5} = 'Resub_error';
table_classifiers.Properties.VariableNames{6} = 'TestGen_error';
table_classifiers.Properties.VariableNames{7} = 'Accuracy';

filename = ['05_PDvsStroke_N12obs_N1connMC_4Dphases.xlsx'];
cd('D:\MEG-DBS\analysis\ANALYSIS_2018\Allen_LDA_PDvsStroke');
writetable(table_classifiers,filename);

% Connect to Excel
Excel = actxserver('excel.application');
% Get Workbook object
WB = Excel.Workbooks.Open(fullfile(pwd,filename),0,false);   
% Save Workbook
WB.Save();
% Close Workbook
WB.Close();
% Quit Excel
Excel.Quit();


%% 06: Total coh, use 4 phases as features in LDA ? 4 dimensional 

%1 connection (total), 1/7 time points
%4 phases as LDA input features
load('D:\MEG-DBS\analysis\ANALYSIS_2018\Allen_LDA_PDvsStroke\Beta Coherence_allChannels.mat');
group = reshape(coh.dx,[],1);   %1x12 to 12x1
phase = {'rest','hold','prep','move'};   %2nd rest for diff. #timepoint predictors

mat_classifiers = [0 0 0 0 0 0 0];   %phase(1-4), #timepoint features, #NaNs, #obs, resub error, test/gen error, accuracy
for t=[1:3 5:7];   %time point: baseline (prestim), 5 min into stim, 15 min into stim, stim off now/post stim 0 min, post stim 5 min, post stim 10 min, post stim 15 min
    for ph=1:size(phase,2);   %phase: rest, hold, prep, move
        phase2 = phase{ph};
        coh2(:,ph) = eval(['coh.' phase2 '.total{t,1}']);   %1x1x12 to 12x1 to 12x4 (end of forloop)
    end
    
    %remove column if too many NaNs - manually check
    coh3 = coh2;
    if t==1;   %timepoint1
        ph=[];   
        coh3(:,ph)=[];
    elseif t==2;   %timepoint2
        ph=[];
        coh3(:,ph)=[];
    elseif t==3;   %timepoint3
        ph=[];
        coh3(:,ph)=[];
    %timepoint4 removed at level of forloop    
    elseif t==5;   %timepoint5
        ph=[];
        coh3(:,ph)=[];
    elseif t==6;   %timepoint6
        ph=[];
        coh3(:,ph)=[]; 
    elseif t==7;   %timepoint7
        ph=[];
        coh3(:,ph)=[]; 
    end
    N_col = size(coh3,2);
    
    %remove rows with any NaNs and count remaining subjects
        indices_NaN = any(isnan(coh3),2);
        indices_NaN = find(any(isnan(coh3),2)==1);
        N_NaN = size(indices_NaN,1);
        N_obs = size(coh3,1)-N_NaN;
        coh3_NaNrmv = coh3;
        coh3_NaNrmv(indices_NaN,:)=[];
        group_NaNrmv = group;
        group_NaNrmv(indices_NaN)=[];
    
            lda = fitcdiscr(coh3_NaNrmv,group_NaNrmv);   %LDA
    %         lda = fitcsvm(coh,group);   %SVM
            ldaClass = resubPredict(lda);

            %resubstitution error: misclassification error (the proportion of misclassified observations) on the training set
            ldaResubErr = resubLoss(lda);

            %test/generalization error: expected prediction error on an independent set (resubstitution error will likely under-estimate the test error)
            %without a validation or another labeled 'testing' data set, you can simulate one by doing cross-validation
            %use a stratified 10-fold cross-validation to estimate test error on classification algorithms
            %it randomly divides the training set into 10 disjoint subsets
            %each subset has roughly equal size and roughly the same class proportions as in the training set
            %remove one subset, train the classification model using the other nine subsets, and use the trained model to classify the removed subset
            %you could repeat this by removing each of the ten subsets one at a time

            rng(0,'twister');   %random number generator

            %generate 5(10) disjoint stratified subsets
            cp = cvpartition(group_NaNrmv,'KFold',5);   %5 subsets for 12 subjects. Max is 3 test, 9 train (25%/75%), min depends on #NaNs.

            %estimate the true test error for LDA using 5(10)-fold stratified cross-validation.
            cvlda = crossval(lda,'CVPartition',cp);
            ldaCVErr = kfoldLoss(cvlda);

            %add classifier results to classifier matrix
            mat_classifiers = cat(1,mat_classifiers,[t N_col N_NaN N_obs ldaResubErr*100 ldaCVErr*100 (1-ldaCVErr)*100]);   %phase(1-4), #timepoint features, #NaNs, #obs, resub error, test/gen error, accuracy
end    


%remove empty first row
mat_classifiers2 = mat_classifiers(2:end,:);

%matrix to table, excel spreadsheet
table_classifiers = table(mat_classifiers2(:,1),mat_classifiers2(:,2),mat_classifiers2(:,3),mat_classifiers2(:,4),mat_classifiers2(:,5),mat_classifiers2(:,6),mat_classifiers2(:,7));
table_classifiers.Properties.VariableNames{1} = 'Timepoint';
table_classifiers.Properties.VariableNames{2} = 'N_Phases_asPredictors';
table_classifiers.Properties.VariableNames{3} = 'N_NaNs';
table_classifiers.Properties.VariableNames{4} = 'N_Obs';
table_classifiers.Properties.VariableNames{5} = 'Resub_error';
table_classifiers.Properties.VariableNames{6} = 'TestGen_error';
table_classifiers.Properties.VariableNames{7} = 'Accuracy';

filename = ['06_PDvsStroke_N12obs_N1connTotal_4Dphases.xlsx'];
cd('D:\MEG-DBS\analysis\ANALYSIS_2018\Allen_LDA_PDvsStroke');
writetable(table_classifiers,filename);

% Connect to Excel
Excel = actxserver('excel.application');
% Get Workbook object
WB = Excel.Workbooks.Open(fullfile(pwd,filename),0,false);   
% Save Workbook
WB.Save();
% Close Workbook
WB.Close();
% Quit Excel
Excel.Quit();

