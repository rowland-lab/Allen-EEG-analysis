% Note: Must have run S1,S2,S3 in EEG analysis - Main script
clear all

% Enter gitpath
gitpath='/home/rowlandn/nr_data_analysis/data_scripts/ac/Allen-EEG-analysis';
%gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)

% Enter in protocol folder
protocolfolder='/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/';
%protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Add EEG related paths
allengit_genpaths(gitpath,'EEG')

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*'));
sbj={sbj.name}';

%% Run Code

% Run EEG Lab Processing Pipeline
clear status
parfor i=1%2:21%:numel(sbj)
    status{i,1}=runEEGlab(sbj{i},protocolfolder,gitpath,false,false,true);
end



