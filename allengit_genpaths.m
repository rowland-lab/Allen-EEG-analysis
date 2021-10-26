function allengit_genpaths(gitpath,type)
% allengit_genpaths(gitpath,type)
% gitpath = Path of Allen's cloned github
% type = string input ('imaging','tDCS',or 'EEG')
warning('off','all')

% Add Scripts
addpath(genpath(fullfile(gitpath,'Scripts')))

% Add Functions
addpath(genpath(fullfile(gitpath,'Functions')))

% Add toolboxes
if strcmp(type,'imaging')
    addpath(genpath(fullfile(gitpath,'toolboxes','imaging')))
    rmpath(genpath(fullfile(gitpath,'toolboxes','imaging','spm12')))
    addpath(fullfile(gitpath,'toolboxes','imaging','spm12'))
    spm
    close all
elseif strcmp(type,'tDCS')
    addpath(genpath(fullfile(gitpath,'toolboxes','tDCS modeling')))
elseif strcmp(type,'EEG')
    addpath(genpath(fullfile(gitpath,'toolboxes','EEG')))
    
    % EEGlab
    rmpath(genpath(fullfile(gitpath,'toolboxes','EEG','eeglab-develop')))
    addpath(fullfile(gitpath,'toolboxes','EEG','eeglab-develop'))
    eeglab
    close all
    
    % FieldTrip
    rmpath(genpath(fullfile(gitpath,'toolboxes','EEG','fieldtrip-20200607')))
    addpath(fullfile(gitpath,'toolboxes','EEG','fieldtrip-20200607'))
    ft_defaults
    addpath(fullfile(gitpath,'toolboxes','EEG','fieldtrip-20200607','external','spm12'))
    addpath(fullfile(gitpath,'toolboxes','EEG','fieldtrip-20200607','external','bsmart'))
else
    error('unknown genpath type. acceptable inputs [imaging, tDCS, or EEG]')
end

end
    