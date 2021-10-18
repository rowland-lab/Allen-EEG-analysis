%%
% Note: Must have run S1,S2,S3 in EEG analysis - Main script
clear

% Enter gitpath
gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)

% Enter in protocol folder
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Add EEG related paths
allengit_genpaths(gitpath,'EEG')

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*.'));
sbj={sbj.name}';

%% Run Code

% Preprocess EEGLab (Epoch, Filter, ICA weights)
for i=1:numel(sbj)
    EEGLAB_preprocessing(sbj{i},protocolfolder)
end

% Eliminate ICA components
for i=1:numel(sbj)
    EEGLAB_ICAremoval(sbj{i},protocolfolder)
end

% Time Freq-Analysis (power)
for i=26:numel(sbj)
    EEGLAB_timefreq(sbj{i},protocolfolder)
end

% FieldTrip (imaginary Coherence)
for i=26:numel(sbj)
    EEGLAB_imaginarycoh(sbj{i},protocolfolder)
end

