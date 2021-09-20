function nr_S1_VR_trial_preproc(sbjnum,protocolfolder)
dbstop if error

%% Preprocess VR Trials
% Define folder paths
subjectfolder = fullfile(protocolfolder,sbjnum);
vrDataFolder = fullfile(subjectfolder,'vr');
edffolder = fullfile(subjectfolder,'edf');
analysisfolder=fullfile(subjectfolder,'analysis','S1-VR_preproc');

% Define EEG data path
eegDataFile = fullfile(edffolder,dir(fullfile(edffolder,'*.edf')).name);

% Make analysis folder
mkdir(analysisfolder)

% Find VR files
filePattern = dir(fullfile(vrDataFolder,'TRIAL_*')); % Removed '.' in 'TRIAL_*.'
for i=1:length(filePattern)
    vrDataFolders{i,1}=fullfile(vrDataFolder,filePattern(i).name);
end

% Load VR file
[trialData,vr_chan,tdcs_channels,Session_times] = loadVrTrialData_EEG(vrDataFolders,eegDataFile,{'DC1','DC2'},{'DC3','DC4'},true); % Double-check that all your paths are added
tdcs_chan=tdcs_channels{1};

% % Double check correct channel selection
% pass=false;
% while pass==false
%     figure
%     hold on
%     plot((trialData.eeg.data(:,7)-mean(trialData.eeg.data(:,7)))/std(trialData.eeg.data(:,7))+20)
%     plot((trialData.eeg.data(:,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18)))
%     plot((trialData.eeg.data(:,vr_chan)-mean(trialData.eeg.data(:,vr_chan)))/std(trialData.eeg.data(:,vr_chan))-20)
%     plot(((trialData.eeg.data(:,tdcs_chan)-mean(trialData.eeg.data(:,tdcs_chan)))/std(trialData.eeg.data(:,tdcs_chan))*-1)-40,'LineWidth',2)
%     xlabel('Samples')
%     ylabel('Z-score')
%     legend('C3','C4','VR','tDCS')
%     title('Correct tDCS channel? [y=1,n=2]')
%     x=input('Correct tDCS channel? [y=1,n=2]');
%     
%     if x==2
%         tdcs_chan=input(['Enter new tDCS Channel (previous=',num2str(tdcs_chan),')']);
%     elseif x==1
%         pass=true;
%     end
% end


% Import reference table
import_table=readtable(fullfile(protocolfolder,'Trial Reference.xlsx'));
subj_idx=find(strcmp(import_table.ID,sbjnum));

% Define session information
sessioninfo.patientID=import_table.ID{subj_idx};
sessioninfo.dx=import_table.dx{subj_idx};
sessioninfo.stimlat=import_table.Laterality_brain_{subj_idx};
sessioninfo.stimamp=import_table.Amp(subj_idx);
vr_idx=~cellfun(@isempty,regexp(import_table.Properties.VariableNames,'vrTrial*'));
sessioninfo.trialidx=table2cell(import_table(subj_idx,vr_idx));
sessioninfo.trialnames=sessioninfo.trialidx(~cellfun(@isempty,sessioninfo.trialidx));


% Detect and remove Bad/Non-VR task trials
reject_trials=[];
for i=1:length(trialData.vr)
    if any(length(trialData.vr(i).events.targetHit.time)<=10 | contains(trialData.vr(i).information.quality,'rejected'))
        reject_trials=[reject_trials i];
        disp(['REMOVED BAD/REJECTED TRIALS'])
    elseif ~strcmp(extractAfter(trialData.vr(i).environment.type,'environment '),string(import_table.VREnvironment(subj_idx)))
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

% Create EEG trace and save
figure('units','normalized','outerposition',[0 0 1 1]); hold on
plot((trialData.eeg.data(:,7)-mean(trialData.eeg.data(:,7)))/std(trialData.eeg.data(:,7))+20)
plot((trialData.eeg.data(:,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18)))
plot((trialData.eeg.data(:,vr_chan)-mean(trialData.eeg.data(:,vr_chan)))/std(trialData.eeg.data(:,vr_chan))-20)
plot(((trialData.eeg.data(:,tdcs_chan)-mean(trialData.eeg.data(:,tdcs_chan)))/std(trialData.eeg.data(:,tdcs_chan))*-1)-40,'LineWidth',2)
xlabel('Samples')
ylabel('Z-score')
ylim([-50 40]);
legend('C3','C4','VR','tDCS')
if sessioninfo.stimamp== 0
   title([sbjnum,'-',num2str(sessioninfo.stimamp),'mA-SHAM']);
else
   title([sbjnum,'-',num2str(sessioninfo.stimamp),'mA-ANODAL']);
end
savefig(gcf,fullfile(analysisfolder,'EEG_tDCS_VR Plot'));
close all

%% Detect tDCS signal

% Use tdcsdetect function to detect vr signal and tDCS signal
[tdcs_detect,Session_times,VR_sig] = tdcsdetect(trialData,vr_chan,tdcs_chan,vrDataFolders,Session_times);

sessioninfo.tdcssig.time=tdcs_detect;
sessioninfo.sessionperiod=Session_times;

% Remove VR signals from bad/rejected trials
sessioninfo.vrsig_rejtot=VR_sig;
VR_sig(reject_trials,:)=[];
sessioninfo.vrsig=VR_sig;

if length(trialData.vr)~=numel(sessioninfo.trialnames) || length(sessioninfo.vrsig)~=length(trialData.vr)
    error('ERROR automated trial remove does not match trial reference')
end

% Define trials as pre, intra, or post stimulation
for i=1:length(trialData.vr)
    pattern=sessioninfo.trialnames{i};
    switch pattern(1:3)
        case 'pre'
             trialData.vr(i).information.stimulation=1;
        case 'int'
            trialData.vr(i).information.stimulation=2;
        case 'pos'
            trialData.vr(i).information.stimulation=3;
    end
    trialData.vr(i).information.env=import_table.VREnvironment(subj_idx);
end
%% Save Step 1 info
% Save session info
sessioninfo.s1rejecttrials=reject_trials;
sessioninfo.vrchan=vr_chan;
sessioninfo.tdcschan=tdcs_chan;
sessioninfo.path.vrfolder=vrDataFolder;
sessioninfo.path.edffile=eegDataFile;
sessioninfo.path.sbjfolder=subjectfolder;

% Save preprocessed data
save(fullfile(analysisfolder,[sbjnum,'_S1-VRdata_preprocessed']),'trialData','sessioninfo','-v7.3');

end

