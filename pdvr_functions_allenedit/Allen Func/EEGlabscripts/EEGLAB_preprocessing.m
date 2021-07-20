function EEGLAB_preprocessing(subject,protocolfolder)

subjectfolder=fullfile(protocolfolder,subject);
analysisfolder=fullfile(subjectfolder,'analysis','EEGlab');
mkdir(analysisfolder);

% Load EDF+ file
edf_file=fullfile(subjectfolder,[subject,'.edf']);
EEG = pop_biosig(edf_file,'importevent','off','importannot','off');

% Add Events channel to channel 46
s4_mat=fullfile(subjectfolder,'analysis\S4-FieldTripPreproc\S4-FieldTripPreproc.mat');
EEG=EEGlab_epochimport(s4_mat,EEG);

% Extract Events in channel 46
EEG=pop_chanevent(EEG,46,'edge','leading');

% Downsample to 256
EEG=pop_resample(EEG,256,[],[]);

% High Pass Filter at 0.5Hz
EEG = pop_eegfilt( EEG, 0.5, 0, [], 0, 0, 0, 'fir1',0);

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



% Notch filter at line noise
EEG = pop_eegfilt( EEG, 59, 61, 35, 1 ,0 ,0);

% Find Bad Channels
originalEEG=EEG;
EEGremoval=clean_artifacts(EEG,'Highpass','off','BurstCriterion','off','WindowCriterion','off','WindowCriterionTolerances','off');

if isfield(EEGremoval.etc,'clean_channel_mask')
    % Fix EKG channel auto-rejection
    EEGremoval.etc.clean_channel_mask(22:end)=true;

    % Remove Bad Channels
    channels=[1:26];
    EEG=pop_select(EEG,'channel',channels(EEGremoval.etc.clean_channel_mask));

    % Interpolate channels
    EEG = pop_interp(EEG, originalEEG.chanlocs, 'spherical');
else
    EEG=EEGremoval;
end

% Re-Reference Data (average)
EEG=pop_reref(EEG,[],'exclude',23);

% Select Pre, Intra, Post epochs
vrsig=EEG.sessioninfo.vrsig/4;
for i=1:size(vrsig,1)
    tempeeg=EEG;
    tempeeg.data=tempeeg.data(:,vrsig(i,1):vrsig(i,2));
    tempeeg.times=tempeeg.times(:,vrsig(i,1):vrsig(i,2));
    tempeeg.pnts=size(tempeeg.times,2);
    
    event_idx=[tempeeg.urevent.latency]'>=vrsig(i,1) & [tempeeg.urevent.latency]'<=vrsig(i,2);
    tempeeg.urevent=tempeeg.urevent(event_idx);
    for q=1:size(tempeeg.urevent,2)
        tempeeg.urevent(q).latency=tempeeg.urevent(q).latency-vrsig(i,1);
    end
    
    event_idx=[tempeeg.event.latency]'>=vrsig(i,1) & [tempeeg.event.latency]'<=vrsig(i,2);
    tempeeg.event=tempeeg.event(event_idx);
    for q=1:size(tempeeg.event,2)
        tempeeg.event(q).latency=tempeeg.event(q).latency-vrsig(i,1);
    end
    
    % Perform Artifact Subspace Reconstruction (ASR)
    tempeeg=clean_artifacts(tempeeg,'FlatlineCriterion','off','Highpass','off','ChannelCriterion','off','LineNoiseCriterion','off');

    % Re-Reference Data (average) AGAIN
    tempeeg=pop_reref(tempeeg,[],'exclude',23);

    % Calculate ICA weights
    tempeeg= pop_runica(tempeeg,'icatype','runica');
    
    % Dipole fitting with DIPFIT
    tempeeg= pop_dipfit_settings(tempeeg,'hdmfile','C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\eeglab-develop\plugins\dipfit3.4\standard_BEM\standard_vol.mat','coordformat','MNI','mrifile','C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\eeglab-develop\plugins\dipfit3.4\standard_BEM\standard_mri.mat','chanfile','C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\eeglab-develop\plugins\dipfit3.4\standard_BEM\elec\standard_1005.elc','chansel',[1:21]);
    tempeeg= pop_multifit(tempeeg,[],'threshold',100);
    tempeeg= fitTwoDipoles(tempeeg,'LRR',35);
    
    % Extract Epochs
    tempeeg=pop_epoch(tempeeg,[],[-0.5 1]);
    
    eegevents.(['t',num2str(i)])=tempeeg;
end

% Save structure
save(fullfile(analysisfolder,'Pre-ICA'),'eegevents');

close all
clear all
end