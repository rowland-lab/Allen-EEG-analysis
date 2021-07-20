Rowland_start
close all
clear all
clc

%% Define Subject info
subject='pro00087153_0002';
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Define folders
subjectfolder=fullfile(protocolfolder,subject);
vrfolder=fullfile(subjectfolder,'vr');
eegfile=fullfile(subjectfolder,[subject,'.edf']);
analysisfolder=fullfile(subjectfolder,'analysis');
ft_folder='C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607';

trials={dir(fullfile(vrfolder,'TRIAL*')).name};
for t=1:numel(trials)
    trialfolders{t}=fullfile(vrfolder,trials{t});
end

% Load subject info (S1)
s1_info=load(fullfile(analysisfolder,'S1-VR_preproc',[subject,'_S1-VRdata_preprocessed.mat']));
sessioninfo=s1_info.sessioninfo;

% Load synced EEG and VR
trialData = loadVrTrialData_EEG_ftsync(trialfolders,eegfile,[],[],s1_info.sessioninfo.vrchan,ft_folder);

% EEG info
eeginfo=trialData.eeg.header;
fs=eeginfo.Fs;

% Define reach types (type 1 ; type 2; type 3; type 4]
reach_types=[-0.1 -0.15 0.45;-0.1 0.05 0.45;0.1 0.05 0.45;0.1 -0.15 0.45];

% Define trials and remove stimulation trials
comptrial_idx=[1:numel(sessioninfo.trialnames)];
% comptrial_idx([2 3])=[];

%% Preprocess EEG data
% Add EEGlab
addpath('C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\eeglab-develop');
eeglab
close all

% Load EDF+ file
edf_file=eegfile;
EEG = pop_biosig(edf_file,'importevent','off','importannot','off');

% High Pass Filter at 1 Hz
EEG = pop_eegfilt( EEG, 1, 0, 10, 0, 0, 0, 'fir1',0);

% Load Channel Locations
EEG.chanlocs=pop_chanedit(EEG.chanlocs, 'load',{'C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\EEGLab\Electrode_Loc.ced', 'filetype', 'autodetect'}); 

% Remove Unused Channel data/locations
EEG.chanlocs([21 24:end])=[];
EEG.data([21 24:end],:)=[];
EEG.nbchan=numel(EEG.chanlocs);

% Find Bad Channels
originalEEG=EEG;
EEGremoval=clean_artifacts(EEG,'Highpass','off','BurstCriterion','off','WindowCriterion','off','WindowCriterionTolerances','off');

if isfield(EEGremoval.etc,'clean_channel_mask')
    % Fix EKG, VR, tDCS channel auto-rejection
    EEGremoval.etc.clean_channel_mask(22:end)=true;

    % Remove Bad Channels
    channels=(1:26);
    EEG=pop_select(EEG,'channel',channels(EEGremoval.etc.clean_channel_mask));

    % Interpolate channels
    EEG = pop_interp(EEG, originalEEG.chanlocs, 'spherical');
else
    EEG=EEGremoval;
end

% Downsample to 256
EEG=pop_resample(EEG,256,[],[]);

% Re-Reference Data (average)
EEG=pop_reref(EEG,[],'exclude',23);

% Save to trialData structure
trialData.eeg.data=EEG.data';
trialData.eeg.channels=EEG.chanlocs;
trialData.eeg.header.Fs=EEG.srate;

% Save eeg structure
eegdat=trialData.eeg.data';


%% Perpare Machine Learning Data Structure

for trl=1:numel(comptrial_idx)
    
    trial=comptrial_idx(trl);
    
    %%% Load VR info
    % Define trial folder
    wktrialfolder=fullfile(vrfolder,trials{trial});
    wkposfolder=fullfile(wktrialfolder,'Data');
    wkeventfolder=fullfile(wktrialfolder,'Events');
    wktrialinfofolder=fullfile(wktrialfolder,'trial information.xml');

    % Load trial info
    trialinfo=xml2struct(wktrialinfofolder);

    % Find reach side
    testside=trialinfo.TrialInformation.testedSide.Text;

    % Load VR xyz velocity data
    pos_dat=readtable(wkposfolder);

    % Load Event data
    opts=detectImportOptions(wkeventfolder);
    opts.VariableTypes{4}='char';
    event_dat=readtable(fullfile(wktrialfolder,'Events'),opts);
    
    for cn=1:size(trialData.eeg.data,1)
    
        % Load session EEG
        fs=trialData.eeg.header.Fs;
        trialEEG=trialData.eeg.data(trialData.vr(trial).events.all.time(1)*fs:trialData.vr(trial).events.all.time(end)*fs,cn);

        % Load session VR
        switch testside
            case 'right'
                trialvr_pos=table2array(pos_dat(:,21:29));
            case 'left'
                trialvr_pos=table2array(pos_dat(:,2:10));
        end
        trialvr_time=table2array(pos_dat(:,1));
        
        %%%%%% Match sampling rate of EEG by upsampling VR
        % Calculate samples
        vrsamples=size(trialvr_pos,1);
        eegsamples=size(trialEEG,1);
        
        
        % Pad data and times
        datapadfront=repmat(trialvr_pos(1,:),10000,1);
        datapadback=repmat(trialvr_pos(end,:),10000,1);
        
        tpadfront=trialvr_time(1)-10000*(1/fs):(1/fs):trialvr_time(1)-(1/fs);
        tpadback=trialvr_time(end)+(1/fs):(1/fs):trialvr_time(end)+10000*(1/fs);
        
        % Resample padded data
        [rsvr,rst]=resample([datapadfront;trialvr_pos;datapadback],[tpadfront';trialvr_time;tpadback'],fs);
        
        % Remove padding
        padsamples=size(rsvr,1);
        rmsamples=floor((padsamples-eegsamples)/2);
        trialvr_pos_rs=rsvr(rmsamples:end-rmsamples,:);
        
        % Exactly Match EEG and VR samples
        if size(trialvr_pos_rs,1)~=eegsamples
            trialvr_pos_rs(end,:)=[];
        end
        
        % Train model
        mdl = fitcdiscr(trialvr_pos_rs(1:200,:),trialEEG(1:200));
        


            end

            % Save back to structure
            rt_eegvr(r,:)=tempreach;
        end
    
    
    