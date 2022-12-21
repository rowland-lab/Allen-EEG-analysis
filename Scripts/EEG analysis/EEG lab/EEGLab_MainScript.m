% Note: Must have run S1,S2,S3 in EEG analysis - Main script
clear all

% Enter gitpath
gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)

% Enter in protocol folder
protocolfolder = 'C:\Users\Allen\Documents\data';

% Add EEG related paths
allengit_genpaths(gitpath,'EEG')

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*.'));
sbj={sbj.name}';

%% Options

% Step 1 - Preprocess
opt.icarem.save_procPipeline = true;
opt.icarem.rerun = true;
opt.icarem.ica_auto = true;
opt.icarem.manual = false;
opt.icarem.save_set = true;

% Step 2 - Time Frequency Analysis
opt.tfa.rerun = false;

% Step 3 - FieldTrip (Coherence Anaylsis)
opt.ft.rerun = false;

% Defining Paths
opt.paths.githubpath = gitpath;
opt.paths.protocolfolder = protocolfolder;
%% Run EEG Lab Processing Pipeline

clear status
parfor i=1:numel(sbj)
    status{i,1}=runEEGlab(sbj{i},opt);
end

