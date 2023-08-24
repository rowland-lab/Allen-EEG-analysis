function allengit_genpaths(gitpath,type)
% allengit_genpaths(gitpath,type)
% gitpath = Path of Allen's cloned github
% type = string input ('imaging','tDCS',or 'EEG')
warning('off','all')

if nargin<2
    type='none';
    disp('No toolboxes selected, Only scripts/functions added')
end

disp(['Adding Allens GitHub paths'])

% Add Scripts
disp('Adding Scripts')
addpath(genpath(fullfile(gitpath,'Scripts')))

% Add Functions
disp('Adding Functions')
addpath(genpath(fullfile(gitpath,'Functions')))

% Add toolboxes
if strcmp(type,'imaging')
    disp('Adding Imaging Toolboxes')
    addpath(genpath(fullfile(gitpath,'toolboxes','imaging')))
    rmpath(genpath(fullfile(gitpath,'toolboxes','imaging','spm12')))
    addpath(fullfile(gitpath,'toolboxes','imaging','spm12'))
    spm
    close all
elseif strcmp(type,'tDCS')
    disp('Adding tDCS Toolboxes')
    addpath(genpath(fullfile(gitpath,'toolboxes','tDCS modeling')))
elseif strcmp(type,'EEG')
    disp('Adding EEG Toolboxes')
    addpath(genpath(fullfile(gitpath,'toolboxes','EEG')))   

    % EEGlab
    rmpath(genpath(fullfile(gitpath,'toolboxes','EEG','eeglab2021.1')))
    addpath(fullfile(gitpath,'toolboxes','EEG','eeglab2021.1'))
    eeglab
    close all
    
    %%% Manually add biosig plugin, automatic addition from eeglab DOES NOT
    %%% WORK?!
    cd(dir(which('biosig_installer')).folder);
    biosig_installer
    cd(gitpath)
    
    % FieldTrip
    rmpath(genpath(fullfile(gitpath,'toolboxes','EEG','fieldtrip-20200607')))
    addpath(fullfile(gitpath,'toolboxes','EEG','fieldtrip-20200607'))
    ft_defaults
    addpath(fullfile(gitpath,'toolboxes','EEG','fieldtrip-20200607','external','spm12'))
    addpath(fullfile(gitpath,'toolboxes','EEG','fieldtrip-20200607','external','bsmart'))
elseif strcmp(type,'ECoG')
    addpath(genpath(fullfile(gitpath,'toolboxes','ECoG')))
elseif strcmp(type,'none')
else
    error('unknown genpath type. acceptable inputs [imaging, tDCS, ECoG, or EEG]')
end

clc
disp('Allens GitHub paths completed')

end
    