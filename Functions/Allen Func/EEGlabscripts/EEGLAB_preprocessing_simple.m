function EEGLAB_preprocessing_simple(subject,protocolfolder)

subjectfolder=fullfile(protocolfolder,subject);
analysisfolder=fullfile(subjectfolder,'analysis','EEGlab');
mkdir(analysisfolder);

% Load EDF+ file
edf_file=fullfile(subjectfolder,[subject,'.edf']);
EEG = pop_biosig(edf_file,'importevent','off','importannot','off');

% Load Channel Locations
EEG.chanlocs=pop_chanedit(EEG.chanlocs, 'load',{'C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\EEGLab\Electrode_Loc.ced', 'filetype', 'autodetect'}); 

% Remove Unused Channel data/locations
EEG.chanlocs([21 24:end])=[];
EEG.data([21 24:end],:)=[];
EEG.nbchan=numel(EEG.chanlocs);


% Doesn't work for BIOSEMI??! EDF+
% % Use CleanLine Function to remove line noise
% EEG= pop_cleanline(EEG,'Bandwidth',2,'ChanCompIndices',[1:EEG.nbchan],                  ...
%                    'SignalType','Channels','ComputeSpectralPower',true,             ...
%                    'LineFrequencies',[60 120 180] ,'NormalizeSpectrum',false,           ...
%                    'LineAlpha',0.01,'PaddingFactor',2,'PlotFigures',false,          ...
%                    'ScanForLines',true,'SmoothingFactor',100,'VerboseOutput',1,    ...
%                    'SlidingWinLength',EEG.pnts/EEG.srate,'SlidingWinStep',EEG.pnts/EEG.srate);

% Find Bad Channels
originalEEG=EEG;
EEGremoval=clean_artifacts(EEG,'Highpass','off','BurstCriterion','off','WindowCriterion','off','WindowCriterionTolerances','off');

if isfield(EEGremoval.etc,'clean_channel_mask')
    % Fix EKG, VR, tDCS channel auto-rejection
    EEGremoval.etc.clean_channel_mask(22:end)=true;

    % Remove Bad Channels
    channels=[1:26];
    EEG=pop_select(EEG,'channel',channels(EEGremoval.etc.clean_channel_mask));

    % Interpolate channels
    EEG = pop_interp(EEG, originalEEG.chanlocs, 'spherical');
else
    EEG=EEGremoval;
end


% Save structure
save(fullfile(analysisfolder,'preprocsimple'),'EEG');

close all
clear all
end