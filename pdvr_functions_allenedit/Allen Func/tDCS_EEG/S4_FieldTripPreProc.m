function S4_FieldTripPreProc(sbj,protocolfolder)
% Add Fieldtrip
addpath 'C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607'
ft_defaults
addpath 'C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607\external\spm12'
addpath 'C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607\external\bsmart'

%% Define vars

% Folder
subjectfolder=fullfile(protocolfolder,sbj);

analysisfolder=fullfile(subjectfolder,'analysis','S4-FieldTripPreproc');
mkdir(analysisfolder);

% Import S1-preprocessed data
s1dat=load(fullfile(subjectfolder,'analysis','S1-VR_preproc',[sbj,'_S1-VRdata_preprocessed.mat']));
s1dat=s1dat.sessioninfo;

% Import S2-preprocessed data
s2dat=load(fullfile(subjectfolder,'analysis','S2-metrics',[sbj,'_S2-Metrics.mat']));
rejecttrials=s2dat.s2rejecttrials;

% Import S3-preprocessed data
s3dat=load(fullfile(subjectfolder,'analysis','S3-EEGanalysis','s3_dat.mat'));
epochdat=s3dat.epochs;

%% Find Epochs using FieldTrip Compatable EDF read

edffile=dir(fullfile(subjectfolder,'*.edf'));
edffile=fullfile(subjectfolder,edffile.name);
filePattern = dir(fullfile(subjectfolder,'vr','TRIAL_0*'));
for i=1:length(filePattern)
    vrDataFolders{i,1}=fullfile(subjectfolder,'vr',filePattern(i).name);
end
trialData = loadVrTrialData_EEG_ftsync(vrDataFolders,edffile,{'DC1' 'DC2'},false,s1dat.vrchan,'C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607');

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
[tdcs_detect,Session_times,VR_sig] = tdcsdetect(trialData,s1dat.vrchan,s1dat.tdcschan);

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
%% Detect Epochs

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

ft_vrdat=trialData.vr;
ft_sessioninfo=sessioninfo;
ft_epochs=epochs;
%% Save variable

save(fullfile(analysisfolder,'S4-FieldTripPreproc.mat'),'ft_vrdat','ft_sessioninfo','ft_epochs')
end