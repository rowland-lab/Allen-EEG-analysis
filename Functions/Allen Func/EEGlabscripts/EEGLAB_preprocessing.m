function EEGLAB_preprocessing(subject,protocolfolder)

% Define folder paths
subjectfolder=fullfile(protocolfolder,subject);
analysisfolder=fullfile(subjectfolder,'analysis','EEGlab');
edf_file=fullfile(subjectfolder,'edf',[subject,'.edf']);
vrfolder=fullfile(subjectfolder,'vr');

% Import S1-preprocessed data
s1dat=load(fullfile(subjectfolder,'analysis','S1-VR_preproc',[subject,'_S1-VRdata_preprocessed.mat']));
s1dat=s1dat.sessioninfo;

% Import S2-preprocessed data
s2dat=load(fullfile(subjectfolder,'analysis','S2-metrics',[subject,'_S2-Metrics.mat']));
rejecttrials=s2dat.s2rejecttrials;

% Import S3-preprocessed data
s3dat=load(fullfile(subjectfolder,'analysis','S3-EEGanalysis','s3_dat.mat'));
epochdat=s3dat.epochs;


% Make eeglab analysis folder
mkdir(analysisfolder);

% Find VR files
filePattern = dir(fullfile(vrfolder,'TRIAL_*')); % Removed '.' in 'TRIAL_*.'
for i=1:length(filePattern)
    vrDataFolders{i,1}=fullfile(vrfolder,filePattern(i).name);
end
%% Preprocess EDF file for eeglab functions
% Load EDF+ file
[trialData,EEG]=loadVrTrialData_EEGlab(vrDataFolders,edf_file,{'DC1','DC2'},true,43);


% Detect and remove Bad/Non-VR task trials
reject_trials=[];
for i=1:length(trialData.vr)
    if any(length(trialData.vr(i).events.targetHit.time)<=10 | contains(trialData.vr(i).information.quality,'rejected'))
        reject_trials=[reject_trials i];
        disp(['REMOVED BAD/REJECTED TRIALS'])
    end  
end
trialData.vr(reject_trials)=[];

% Remove outside position sub-trials within each trials
for i=1:length(trialData.vr)
    if isempty(trialData.vr(i).events.outsideStartPosition.time)
        continue
    else
        % Find VR events/sort
        clearvars epochs_temp
        atStartPositioncount=0;
        for t=1:length(trialData.vr(i).events.all.all)
            switch trialData.vr(i).events.all.all{t}
                case 'atStartPosition'
                    atStartPositioncount=atStartPositioncount+1;
                    eval(['epochs_temp{',num2str(t),',1}=[''trial(',num2str(i),')_',trialData.vr(i).events.all.all{t},'_event(',num2str(atStartPositioncount),')''];']);
                    eval(['epochs_temp{',num2str(t),',2}=trialData.vr(',num2str(i),').events.all.all{',num2str(t),',2};'])        
                case 'cueEvent'
                    eval(['epochs_temp{',num2str(t),',1}=[''trial(',num2str(i),')_',trialData.vr(i).events.all.all{t},'_event(',num2str(atStartPositioncount),')''];']);
                    eval(['epochs_temp{',num2str(t),',2}=trialData.vr(',num2str(i),').events.all.all{',num2str(t),',2};'])
                case 'targetUp'
                    eval(['epochs_temp{',num2str(t),',1}=[''trial(',num2str(i),')_',trialData.vr(i).events.all.all{t},'_event(',num2str(atStartPositioncount),')''];']);
                    eval(['epochs_temp{',num2str(t),',2}=trialData.vr(',num2str(i),').events.all.all{',num2str(t),',2};'])
                case 'outsideStartPosition'   
                    eval(['epochs_temp{',num2str(t),',1}=[''trial(',num2str(i),')_',trialData.vr(i).events.all.all{t},'_event(',num2str(atStartPositioncount),')''];']);
                    eval(['epochs_temp{',num2str(t),',2}=trialData.vr(',num2str(i),').events.all.all{',num2str(t),',2};'])
            end
        end
        epochs_temp=epochs_temp(~all(cellfun('isempty',epochs_temp),2),:);


        for q=1:length(epochs_temp)
            try
                epochs_temp{q,3}=epochs_temp{q+1,2};       
            catch
                epochs_temp{q,3}=trialData.vr(i).events.stop.time;
            end
        end   


        % Identify bad trials and remove
        outsideStartPosition_num=regexp(epochs_temp(contains(epochs_temp(:,1),'outsideStartPosition')),'\d*','Match');
        outsideStartPosition_num=cellfun(@(x) x(2),outsideStartPosition_num);
        if length(trialData.vr(i).events.atStartPosition.time)>12
            trialData.vr(i).events.atStartPosition.time(str2double(outsideStartPosition_num))=[];
        end
        if length(trialData.vr(i).events.waitingForCue.time)>12
            trialData.vr(i).events.waitingForCue.time(str2double(outsideStartPosition_num))=[];
        end
    end
    disp(['REMOVED BAD SUB-TRIALS']) 
end

% Detect tDCS/VR signals
sessioninfo=s1dat;
[tdcs_detect,Session_times,VR_sig] = tdcsdetect(trialData,s1dat.vrchan,s1dat.tdcschan,7000);

sessioninfo.tdcssig.time=tdcs_detect;
sessioninfo.sessionperiod=Session_times;

% Remove VR signals from bad/rejected trials
sessioninfo.vrsig_rejtot=VR_sig;
VR_sig(sessioninfo.s1rejecttrials,:)=[];
sessioninfo.vrsig=VR_sig;

if length(trialData.vr)~=numel(sessioninfo.trialnames) || length(sessioninfo.vrsig)~=length(trialData.vr)
    error('ERROR automated trial remove does not match trial reference')
end

% Remove s2 detected bad trials
for i=1:size(s2dat.s2rejecttrials,1)
    trialData.vr(s2dat.s2rejecttrials(i,1)).events.atStartPosition.time(s2dat.s2rejecttrials(i,2))=[];
    trialData.vr(s2dat.s2rejecttrials(i,1)).events.cueEvent.time(s2dat.s2rejecttrials(i,2))=[];
    trialData.vr(s2dat.s2rejecttrials(i,1)).events.targetUp.time(s2dat.s2rejecttrials(i,2))=[];
end

% Detect Epochs

% Epoch length in seconds
epochlength=60;
buffer=1;

% Channel Number
chan_num=1:22;

Session_times= sessioninfo.sessionperiod;
VR_sig=sessioninfo.vrsig;


clc
x=2;
close all

while x~=1

    % Epoch VR whole trials
    epochs.vrwhole.val(:,1)=mean(VR_sig(:,1:2),2)-((epochlength*trialData.eeg.header.Fs)/2);
    epochs.vrwhole.val(:,2)=mean(VR_sig(:,1:2),2)+((epochlength*trialData.eeg.header.Fs)/2);

    % Epoch Rest trials
    for i=1:length(VR_sig)
        if i==1
            epochs.rest.val(i,1)=VR_sig(i,1)-(buffer*trialData.eeg.header.Fs)-(epochlength*trialData.eeg.header.Fs);
        end
        epochs.rest.val(i,1)=VR_sig(i,1)-(buffer*trialData.eeg.header.Fs)-(epochlength*trialData.eeg.header.Fs);
    end
    epochs.rest.val(:,2)=epochs.rest.val(:,1)+(epochlength*trialData.eeg.header.Fs);


    % Epoch VR events
    epocheventtypes={'atStartPosition','cueEvent','targetUp'};
    epocheventlabels={'Hold','Prep','Move'};

    min_epochlength=[];
    for i=1:length(trialData.vr)
        for t=1:length(epocheventtypes)
            switch epocheventtypes{t}
                case 'atStartPosition'
                    eval(['epochs.vrevents.t',num2str(i),'.atStartPosition.val=trialData.vr(i).events.',epocheventtypes{t},'.time(:)*trialData.eeg.header.Fs;'])
                case 'cueEvent'
                    eval(['epochs.vrevents.t',num2str(i),'.cueEvent.val=trialData.vr(i).events.',epocheventtypes{t},'.time(:)*trialData.eeg.header.Fs;'])
                    min_epochlength=[min_epochlength; eval(['epochs.vrevents.t',num2str(i),'.cueEvent.val'])];
                case 'targetUp'
                    eval(['epochs.vrevents.t',num2str(i),'.targetUp.val=trialData.vr(i).events.',epocheventtypes{t},'.time(:)*trialData.eeg.header.Fs;'])
                    min_epochlength=[min_epochlength; eval(['epochs.vrevents.t',num2str(i),'.targetUp.val'])];
            end
        end
    end
    min_epochlength=min(diff(sort(min_epochlength)));

    for i=1:length(fieldnames(epochs.vrevents))
        fn=fieldnames(epochs.vrevents);
        for z=1:length(epocheventtypes)
            epochs.vrevents.(fn{i}).(epocheventtypes{z}).val(:,2)=epochs.vrevents.(fn{i}).(epocheventtypes{z}).val(:,1)+min_epochlength;
        end
    end

    %%%%%%%%%% Check if properly epoched %%%%%%%%%%
    figure
    hold on
    plot((trialData.eeg.data(:,7)-mean(trialData.eeg.data(:,7)))/std(trialData.eeg.data(:,7)))
    plot((trialData.eeg.data(:,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18))-20)
    plot((trialData.eeg.data(:,23)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,23))-40)
    plot((trialData.eeg.data(:,sessioninfo.vrchan)-mean(trialData.eeg.data(:,sessioninfo.vrchan)))/std(trialData.eeg.data(:,sessioninfo.vrchan))-60)
    plot(((trialData.eeg.data(:,sessioninfo.tdcschan)-mean(trialData.eeg.data(:,sessioninfo.tdcschan)))/std(trialData.eeg.data(:,sessioninfo.tdcschan))*-1)-80,'LineWidth',2)
    xlim([Session_times{1} Session_times{2}]);
    yplotlim=get(gca,'ylim');

    % Add rest epochs
    for i=1:length(epochs.rest.val)
        h1=plot([epochs.rest.val(i,1) epochs.rest.val(i,1)],yplotlim,'-g','LineWidth',2);
        plot([epochs.rest.val(i,2) epochs.rest.val(i,2)],yplotlim,'-r','LineWidth',2);
        text(mean([epochs.rest.val(i,1) epochs.rest.val(i,2)]),yplotlim(2)*0.9,["Rest Epoch",num2str(i)],'HorizontalAlign','Center')
    end

    % Add VR whole epochs
    for i=1:length(epochs.vrwhole.val)
        h2=plot([epochs.vrwhole.val(i,1) epochs.vrwhole.val(i,1)],yplotlim,'-.g','LineWidth',1);
        plot([epochs.vrwhole.val(i,2) epochs.vrwhole.val(i,2)],yplotlim,'-.r','LineWidth',1);
        text(mean([epochs.vrwhole.val(i,1) epochs.vrwhole.val(i,2)]),yplotlim(2)*0.9,["VR Epoch",num2str(i)],'HorizontalAlign','Center')
    end

    % Add VR event epochs
    for i=1:length(fieldnames(epochs.vrevents))
        for z=1:length(epocheventtypes)
            temp_val=eval(['epochs.vrevents.t',num2str(i),'.',epocheventtypes{z},'.val']);
            for q=1:length(temp_val)
                h3=plot([temp_val(q) temp_val(q)],yplotlim,'-b','LineWidth',0.5);
            end
        end
    end

    clearvars eventtimelist
    for i=1:length(trialData.vr)
        fieldnamesevents=fieldnames(trialData.vr(i).events);
        eventtimelist=0;
        for t=1:length(fieldnamesevents)-1
            eval(['eventtimes=trialData.vr(i).events.',fieldnamesevents{t+1},'.time;'])
            for q=1:length(eventtimes)
                if any(eventtimelist==eventtimes(q))
                    text(eventtimes(q)*1024,0,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q)],'FontSize',11,'Rotation',-90)
                else
                    text(eventtimes(q)*1024,0,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q)],'FontSize',11,'Rotation',90)
                end
                eventtimelist=[eventtimelist eventtimes(q)];
            end
        end   
    end

    legend('C3','C4','EKG','VR','tDCS')

    x=input('Correctly Epoched? [y=1,n=2]');
    if x==2
        epochlength=input(['Enter new Epoch Length (previous=',num2str(epochlength),')']);
        buffer=input(['Enter new Buffer Length (previous=',num2str(buffer),')']);
    end
    close all
end


%% EEGlab code
% Add Events channel to channel 46
EEG=EEGlab_epochimport(trialData,sessioninfo,epochs,EEG);

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