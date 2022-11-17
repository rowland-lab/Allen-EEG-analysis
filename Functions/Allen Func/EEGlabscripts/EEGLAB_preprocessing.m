function eegevents=EEGLAB_preprocessing(subject,opt)

protocolfolder = opt.paths.protocolfolder;
gitpath = opt.paths.githubpath;
save_procPipeline = opt.save_procPipeline;
manual = opt.icarem.manual;
auto = opt.icarem.ica_auto;

% Define folder paths
subjectfolder=fullfile(protocolfolder,subject);
analysisfolder=fullfile(subjectfolder,'analysis','EEGlab');
edf_file=fullfile(subjectfolder,'edf',[subject,'.edf']);
vrfolder=fullfile(subjectfolder,'vr');

% Check if to see if processed already
if exist(fullfile(analysisfolder,'EEGlab_Total.mat'),'file') && ~opt.icarem.rerun
    EEGlab_Total = load(fullfile(analysisfolder,'EEGlab_Total.mat'));
    if isfield(EEGlab_Total,'eegevents_icarem')
        eegevents = EEGlab_Total.eegevents_icarem;
        return
    end
end


% Import S1-preprocessed data
disp('Loading S1 data...')
s1dat=load(fullfile(subjectfolder,'analysis','S1-VR_preproc',[subject,'_S1-VRdata_preprocessed.mat']));
s1dat=s1dat.sessioninfo;

% Import S2-preprocessed data
disp('Loading S2 data...')
s2dat=load(fullfile(subjectfolder,'analysis','S2-metrics',[subject,'_S2-Metrics.mat']));
rejecttrials=s2dat.s2rejecttrials;

% Import S3-preprocessed data
disp('Loading S3 data...')
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
disp('Loading EDF+ file...')
[trialData,EEG,VR_chan]=loadVrTrialData_EEGlab(vrDataFolders,edf_file,{'DC1','DC2'},false,s1dat.vrchanLabel);
fs = trialData.eeg.header.Fs;

% Save processing data
if save_procPipeline
    EEG.processingData{1}.data=EEG.data;
    EEG.processingData{1}.details='Import';
end

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


% Epoch length in seconds
epochlength=60;
buffer=1;

% Detect tDCS/VR signals
sessioninfo=s1dat;
if manual
    [tdcs_detect,Session_times,VR_sig] = tdcsdetect(trialData,VR_chan,sessioninfo.tdcschan,vrDataFolders);
else
    Session_positions{1}=1;
    Session_positions{2}=size(trialData.eeg.data,1);
    [tdcs_detect,Session_times,VR_sig] = tdcsdetect(trialData,VR_chan,sessioninfo.tdcschan,vrDataFolders,Session_positions);
    Session_times{1}=VR_sig(1)-(epochlength*trialData.eeg.header.Fs);
    Session_times{2}=VR_sig(end)+(epochlength*trialData.eeg.header.Fs);
    if Session_times{2}>size(trialData.eeg.data,1)
        Session_times{2}=size(trialData.eeg.data,1);
    end
end

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

Session_times= sessioninfo.sessionperiod;
VR_sig=sessioninfo.vrsig;


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

% Find Movement start
movementstart = [];
fn = fieldnames(s2dat.movementstart);
for i = 1:numel(fn)
    movementstart = cat(1,movementstart,s2dat.movementstart.(fn{i}){:});
end
for i = 1:size(movementstart,1)
    movementstart(i,:) = (movementstart(i,:).*fs + VR_sig(i,1));
end

clc
if manual
    x=2;
else
    x=1;
end
close all
while x~=1
    %%%%%%%%%% Check if properly epoched %%%%%%%%%%
    figure
    hold on
    plot((trialData.eeg.data(:,7)-mean(trialData.eeg.data(:,7)))/std(trialData.eeg.data(:,7)))
    plot((trialData.eeg.data(:,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18))-20)
    plot((trialData.eeg.data(:,23)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,23))-40)
    plot((trialData.eeg.data(:,VR_chan)-mean(trialData.eeg.data(:,VR_chan)))/std(trialData.eeg.data(:,VR_chan))-60)
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
    
    % Add movement start
    for i = 1:numel(movementstart)
        plot([movementstart(i) movementstart(i)],yplotlim,'-c','LineWidth',0.5);
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
EEG=EEGlab_epochimport(trialData,sessioninfo,epochs,EEG,movementstart);

% Extract Events in channel 46
EEG=pop_chanevent(EEG,46,'edge','leading');

% Add Reach number and trial tag to events
for i=1:length(EEG.event)
    
    % Calculate trial number
    temptrial=num2str(EEG.event(i).type);
    temptrial=str2num(temptrial(1));
    
    % Calculate phase number
    tempphase=mod(EEG.event(i).type,10);
    
    % Calculate reach number
    if i==1
        trialcounter=1;
        tempreach=1;
        newtrialcounter=1;
    else
        newtrialcounter=temptrial;
        if tempphase==1
            tempreach=tempreach+1;
        end
    end
    
    
    if trialcounter~=newtrialcounter
        tempreach=1;
        trialcounter=newtrialcounter;
    end
        
    % Save numbers
    EEG.event(i).trial=temptrial;
    EEG.event(i).reach=tempreach;
    EEG.event(i).phase=tempphase;
end

% Remove s2 rejected trials
EEG.s2rejectedTrials=rejecttrials;
rmidx=[];
for i=1:size(rejecttrials,1)
    rmidx=[find(cellfun(@(x) x==rejecttrials(i,1),{EEG.event.trial}) & cellfun(@(x) x==rejecttrials(i,2),{EEG.event.reach})) rmidx];
end
EEG.event(rmidx)=[];

% Reduce data down to only VR session
EEG.data=EEG.data(:,EEG.sessioninfo.sessionperiod{1}:EEG.sessioninfo.sessionperiod{2});
EEG.times=EEG.times(:,EEG.sessioninfo.sessionperiod{1}:EEG.sessioninfo.sessionperiod{2});
EEG.pnts=size(EEG.data,2);
for i=1:size(EEG.event,2)
    EEG.event(i).latency=EEG.event(i).latency-EEG.sessioninfo.sessionperiod{1};
end

% Downsample to 256
EEG=pop_resample(EEG,256,[],[]);

% Save processing data
if save_procPipeline
    EEG.processingData{2}.data=EEG.data;
    EEG.processingData{2}.details='Downsample to 256';
end

% High Pass Filter at 0.5Hz
EEG = pop_eegfilt( EEG, 0.5, 0, [], 0, 0, 0, 'fir1',0);

% Save processing data
if save_procPipeline
    EEG.processingData{3}.data=EEG.data;
    EEG.processingData{3}.details='High Pass Filter (0.5)';
end

% Load Channel Locations
EEG.chanlocs=pop_chanedit(EEG.chanlocs, 'load',{fullfile(gitpath,'toolboxes','EEG','etc','eeglab_electrodeLoc','Electrode_Loc.ced'), 'filetype', 'autodetect'});

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

% Save processing data
if save_procPipeline
    EEG.processingData{4}.data=EEG.data;
    EEG.processingData{4}.details='Notch Filter';
end

% Select Pre, Intra, Post epochs
fsReduc=trialData.eeg.header.Fs/EEG.srate;
vrsig=EEG.sessioninfo.vrsig/(fsReduc)-(EEG.sessioninfo.sessionperiod{1}/fsReduc);
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
    
    % Save processing data
    if save_procPipeline
        tempeeg.processingData{5}.data=tempeeg.data;
        tempeeg.processingData{5}.VRsignal=vrsig(i,:);
        tempeeg.processingData{5}.details={'Trial Epoch'};
    end
    
%     % Rereference to average
%     tempeeg=pop_reref(tempeeg,[]);
%     
%     % Save processing data
%     if save_procPipeline
%         tempeeg.processingData{7}.data=tempeeg.data;
%         tempeeg.processingData{7}.details='Rereference to average';
%     end
    
    % Calculate ICA weights
    tempeeg= pop_runica(tempeeg,'icatype','runica');
    tempeeg.icaact = icaact(tempeeg.data,tempeeg.icaweights*tempeeg.icasphere);
    
%     % Dipole fitting with DIPFIT
%     tempeeg= pop_dipfit_settings(tempeeg,'hdmfile','C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\eeglab-develop\plugins\dipfit3.4\standard_BEM\standard_vol.mat','coordformat','MNI','mrifile','C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\eeglab-develop\plugins\dipfit3.4\standard_BEM\standard_mri.mat','chanfile','C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\eeglab-develop\plugins\dipfit3.4\standard_BEM\elec\standard_1005.elc','chansel',[1:21]);
%     tempeeg= pop_multifit(tempeeg,[],'threshold',100);
%     tempeeg= fitTwoDipoles(tempeeg,'LRR',35);
%     
    % Calculate coherence between EKG channel and components
    figure;comp_data=pop_plotdata(tempeeg,0,[1:size(tempeeg.icawinv,2)]);
    heart_data=tempeeg.data(strcmp({tempeeg.chanlocs.labels},'EKG'),:);
    close all
    
    coh=[];
    for c=1:size(comp_data,1)
        coh(c)=mean(mscohere(zscore(comp_data(c,:)),zscore(heart_data),[],[],[],tempeeg.srate));
    end
    
    % Calculate heart Coherence
    [heart_coh,heart_idx]=max(coh);
    tempeeg.heart.coh=heart_coh;
    tempeeg.heart.idx=heart_idx;
    tempeeg.heart.heart_data=heart_data;
    tempeeg.heart.zScore=zscore(coh);
    tempeeg.heart.zScore=tempeeg.heart.zScore(heart_idx);
    
    % Remove ICA components
    if auto
        disp(['Heart component coherence ---',num2str(heart_coh)])
        disp(['Heart component coherence zScore ---',num2str(tempeeg.heart.zScore)])
        if tempeeg.heart.zScore>2
            tempeeg.rcmp.idx=heart_idx;
            tempeeg.rcmp.data=comp_data(heart_idx,:);
            tempeeg=pop_subcomp(tempeeg,tempeeg.rcmp.idx,0);
        else
            disp('Heart Coherence unable to be autodetected')
            tempeeg.rcmp=nan;
        end
    else
        % Run ICA label
        tempeeg = iclabel(tempeeg);
        
        % Visualize ICA labels
        pop_viewprops(tempeeg,0,[1:size(tempeeg.icaweights,1)],'freqrange', [2 80]);
        
        % Visualize potential components
        figure;
        sgtitle([sessioninfo.patientID,'-stimside(',tempeeg.sessioninfo.stimlat,')']);
        
        subplot(1,2,1)
        coh_b=bar(coh);
        coh_b.FaceColor = 'flat';
        coh_b.CData(heart_idx,:)=[1 0 0];
        ytips = coh_b.YEndPoints(heart_idx);
        text(heart_idx,ytips,string(heart_idx),'HorizontalAlignment','center',...
            'VerticalAlignment','bottom');
        ylim([0 1]);
        ylabel('Coherence with EKG channel');
        xlabel('Components');
        title('Likely Heart Component');
        
        subplot(1,2,2)
        positive_idx=find(c_movevar>0);
        compvar_b=bar(c_movevar);
        compvar_b.FaceColor='flat';
        compvar_b.CData(move_idx,:)=[1,0,0];
        for p=1:numel(positive_idx)
            ytips = double(compvar_b.YEndPoints(positive_idx(p)));
            text(positive_idx(p),ytips,string(positive_idx(p)),'HorizontalAlignment','center',...
                'VerticalAlignment','bottom');
        end
        ylim([0 2]);
        ylabel('Z-var movement score');
        xlabel('Components');
        title('Likely Movement Component(s)');
        rcmp=input('ICA components to remove ..[#,#]-->');
        tempeeg=pop_subcomp(tempeeg,rcmp,1);
    end
    
    % Find Bad Channels
    originaltempEEG=tempeeg;
    EEGremoval=clean_artifacts(tempeeg,'Highpass','off','BurstCriterion','off','WindowCriterion','off','WindowCriterionTolerances','off');

    if isfield(EEGremoval.etc,'clean_channel_mask')
        % Fix EKG channel auto-rejection
        EEGremoval.etc.clean_channel_mask(22:end)=true;
        
        % Find Bad channels
        badchan=find(~EEGremoval.etc.clean_channel_mask(1:21));

        figure;
        for b=1:numel(badchan)
            ax(b)=nexttile;
            hold on
            plot(tempeeg.data(badchan(b),:));
            title(num2str(badchan(b)));
        end
        
        % Interpolate channels
        tempeeg = pop_interp(EEGremoval, originaltempEEG.chanlocs, 'spherical');
        for b=1:numel(badchan)
            hold(ax(b),'on')
            plot(ax(b),tempeeg.data(badchan(b),:));
        end
        legend({'original','interpolated'});
        sgtitle(['t',num2str(i)]);
        saveas(gcf,fullfile(analysisfolder,['t',num2str(i),'-Interpolated_Channels.fig']))
        close all
        
            
        if numel(badchan)>10
            error(['number of bad channels removal detected is ',num2str(numel(badchan))])
        end
    
        % Save data
        badchanData=originaltempEEG.data(badchan,:);
        badchanData_inter=tempeeg.data(badchan,:);
    else
        badchan=nan;
        badchanData=nan;
        badchanData_inter=nan;
        tempeeg=EEGremoval;
    end
    tempeeg.badChannels.channels=badchan;
    tempeeg.badChannels.data=badchanData;
    tempeeg.badChannels.data_inter=badchanData_inter;
    
    % Save processing data
    if save_procPipeline
        tempeeg.processingData{6}.data=tempeeg.data;
        tempeeg.processingData{6}.details='Removed Bad channels and interpolate';
    end

    % Perform Artifact Subspace Reconstruction (ASR) --> REMOVES EPOCHS
    % based on WINDOWCRITERION [Default-0.25]
    tempeeg=clean_artifacts(tempeeg,'FlatlineCriterion','off','Highpass','off','ChannelCriterion','off','LineNoiseCriterion','off','WindowCriterion',0.3);
    tempeeg.ASRrmvIdx=tempeeg.event;
    
    % Save processing data
    if save_procPipeline
        tempeeg.processingData{7}.data=tempeeg.data;
        tempeeg.processingData{7}.details={'Artifact Subspace Reconstruction'};
    end

    if opt.icarem.save_set
        % Save as set file
        pop_saveset(tempeeg, 'filepath', fullfile(analysisfolder,['t',num2str(i),'_preproc.set']));
    end

    % Extract Epochs
    [tempeeg,indices]=pop_epoch(tempeeg,[],[-0.25 1]);
    tempeeg.ASRrmvIdx(indices)=[];
    
    if isempty(tempeeg.epoch)
        figure;
        hold on
        plot(vrsig(i,1):vrsig(i,2),EEG.data(7,vrsig(i,1):vrsig(i,2)));
        plot(vrsig(i,1):vrsig(i,2),EEG.data(vrsig(i,1):vrsig(i,2)));
        error('epoch field empty')
    end
    
    % Save processing data
    if save_procPipeline
        tempeeg.processingData{8}.data=tempeeg.data;
        tempeeg.processingData{8}.details={'Reach epoched'};
    end
    
    eegevents.trials.(['t',num2str(i)])=tempeeg;
    
end


% % Save structure
% save(fullfile(analysisfolder,'Pre-ICA'),'eegevents','-v7.3');

% Preprocessing step completion tag
eegevents.pipeline.preprocessing=true;

close all
end