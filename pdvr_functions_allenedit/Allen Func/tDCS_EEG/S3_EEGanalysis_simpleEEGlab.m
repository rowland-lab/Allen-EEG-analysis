% Channel Reference
% {'Fp1' }
% {'F7'  }
% {'T3'  }
% {'T5'  }
% {'O1'  } 5
% {'F3'  }
% {'C3'  } 7
% {'P3'  }
% {'A1'  }
% {'Fz'  } 10
% {'Cz'  }
% {'Fp2' }
% {'F8'  }
% {'T4'  }
% {'T6'  }
% {'O2'  }
% {'F4'  }
% {'C4'  } 18
% {'P4'  }
% {'A2'  }20
% {'Fpz' }
% {'Pz'  }
% {'X1'  }23 [EKG]
% {'X2'  }
% {'X3'  }25
% {'X4'  }
% {'X5'  }
% {'X6'  }
% {'X7'  }
% {'X8'  }30
% {'X9'  }
% {'X10' }
% {'X11' }
% {'X12' }
% {'X13' }35
% {'X14' }
% {'X15' }
% {'X16' }
% {'X17' }
% {'X18' }40
% {'DC1' } 41- VR
% {'DC2' } 42- VR
% {'DC3' } 43- tDCS
% {'DC4' } 44- tDCS
% {'OSAT'}
% {'PR'  }

%% Enter Info
    
function S3_EEGanalysis_simpleEEGlab(sbjnum,protocolfolder)
close all
clc

% sbjnum='pro00087153_0001';
% protocolfolder='C:\Box Sync\Allen_Rowland_EEG\protocol_00087153';
% protocolfolder='C:\Users\allen\Box Sync\Allen_Rowland_EEG\protocol_00087153';


%% Define variables and import data

sbjfolder=fullfile(protocolfolder,sbjnum);
analysisfolder=fullfile(sbjfolder,'analysis');
eeganalysisfolder=fullfile(analysisfolder,'S3-EEGanalysis_simple');
mkdir(eeganalysisfolder)

edffile=fullfile(sbjfolder,[sbjnum,'.edf']);

restvrfolder=fullfile(eeganalysisfolder,'restvr');
mkdir(restvrfolder)

vrepochfolder=fullfile(eeganalysisfolder,'vrepoch');
mkdir(vrepochfolder)

% Detect and import S1 info file
importdataS1=load(fullfile(analysisfolder,'S1-VR_preproc',[sbjnum,'_S1-VRdata_preprocessed_simple.mat']));
sessioninfo=importdataS1.sessioninfo;
trial_label=sessioninfo.trialnames;
figtitle=[sessioninfo.patientID,'-',sessioninfo.dx,'-',sessioninfo.stimlat];

% Detect and import S2 file
importdataS2=load(fullfile(analysisfolder,'S2-metrics',[sbjnum,'_S2-Metrics_simple']));
S2_trialdat=importdataS2.trialData.vr;
movementstart=struct2cell(importdataS2.movementstart);
movementstart=[movementstart{:}]

% Detect and import eeglab preproc file
importdataeeglab=load(fullfile(analysisfolder,'EEGlab','preprocsimple.mat'));
% Read edf
filePattern = dir(fullfile(sbjfolder,'vr','TRIAL_*.'));
for i=1:length(filePattern)
    vrDataFolders{i,1}=fullfile(sbjfolder,'vr',filePattern(i).name);
end
trialData = loadVrTrialData_EEG_ftsync(vrDataFolders,edffile,{'DC1' 'DC2'},false,sessioninfo.vrchan,'C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607');

% Replace eeg with preproc eeg from eeglab
trialData.eeg.data(:,1:20)=importdataeeglab.EEG.data(1:20,:)';
trialData.eeg.data(:,22)=importdataeeglab.EEG.data(21,:)';

% Replace VR trials with preproc VR trials
trialData.vr=S2_trialdat;

%%%%%%%%%%%%%%%%%% Applying Filters %%%%%%%%%%%%%%%%%%%%

% Alternating current filter
[n1_b, n1_a]=butter(3,2*[57 63]/trialData.eeg.header.Fs,'stop');%60 Hz
[n2_b, n2_a]=butter(3,2*[117 123]/trialData.eeg.header.Fs,'stop');%120 Hz
[n3_b, n3_a]=butter(3,2*[177 183]/trialData.eeg.header.Fs,'stop');%180 Hz

trialData.eeg.data=filtfilt(n1_b,n1_a,trialData.eeg.data);
trialData.eeg.data=filtfilt(n2_b,n2_a,trialData.eeg.data);
trialData.eeg.data=filtfilt(n3_b,n3_a,trialData.eeg.data);

%% Epochs (Movement, Rest)

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
    figure('Name',['Epoched EEG signal graph==',figtitle],'units','normalized','outerposition',[0 0 1 1]); 
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
% % % % % %     
% % % % % %     % Create movement figures
% % % % % %     coi=[7 18];
% % % % % %     for cn=1:numel(coi)
% % % % % %         for i=1:length(fieldnames(epochs.vrevents))
% % % % % %             figure
% % % % % %             sgtitle([trial_label{i},' Channel ',string(coi(cn))])
% % % % % %             move_start=eval(['epochs.vrevents.t',num2str(i),'.',epocheventtypes{3},'.val']);
% % % % % %             for ms=1:length(temp_val)
% % % % % %                 subplot(2,ceil(length(temp_val)/2),ms)
% % % % % %                 plot((trialData.eeg.data(:,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18)))
% % % % % %                 clearvars eventtimelist
% % % % % %                 for trial=1:length(trialData.vr)
% % % % % %                     fieldnamesevents={'targetUp','targetHit'};
% % % % % %                     eventtimelist=0;
% % % % % %                     for t=1:length(fieldnamesevents)
% % % % % %                         eval(['eventtimes=trialData.vr(i).events.',fieldnamesevents{t},'.time;'])
% % % % % %                         for q=1:length(eventtimes)
% % % % % %                             if any(eventtimelist==eventtimes(q))
% % % % % %                                 h=text(eventtimes(q)*1024,0,['\leftarrow',fieldnamesevents{t},' ',num2str(q)],'FontSize',11,'Rotation',-90);
% % % % % %                             else
% % % % % %                                 h=text(eventtimes(q)*1024,0,['\leftarrow',fieldnamesevents{t},' ',num2str(q)],'FontSize',11,'Rotation',90);
% % % % % %                             end
% % % % % %                             set (h, 'Clipping', 'on');
% % % % % %                             eventtimelist=[eventtimelist eventtimes(q)];
% % % % % %                         end
% % % % % %                     end   
% % % % % %                 end
% % % % % %                 xlim([move_start(ms,1) move_start(ms,1)+2*1024]) 
% % % % % %                 currentgca=gca;
% % % % % %                 xTickseconds=currentgca.XTick/1024;
% % % % % %                 currentgca.XTickLabel=string(round(xTickseconds-xTickseconds(1),2));
% % % % % %                 ylim([-1 1])
% % % % % %                 xlabel({'Seconds'})
% % % % % %             end
% % % % % %             saveas(gcf,fullfile('C:\Users\allen\Desktop\EEG traces',[trial_label{i},'_Channel_',num2str(coi(cn))]))
% % % % % %         end
% % % % % %     end

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
end

saveas(gcf,fullfile(eeganalysisfolder,[get(gcf,'Name'),'.jpg']))
close all

%%%%%%%%%%%%%%% Calculate Power Spectral Density %%%%%%%%%%%%%%%%5

% PSD VR whole trials epochs
for i=1:length(epochs.vrwhole.val)
    [epochs.vrwhole.psd.saw(:,:,i),epochs.vrwhole.psd.freq]=pwelch(trialData.eeg.data(epochs.vrwhole.val(i,1):epochs.vrwhole.val(i,2),chan_num),1024,[],[],1024);
end

% PSD Rest epochs
for i=1:length(epochs.rest.val)
    [epochs.rest.psd.saw(:,:,i),epochs.rest.psd.freq]=pwelch(trialData.eeg.data(epochs.rest.val(i,1):epochs.rest.val(i,2),chan_num),1024,[],[],1024);
end

% PSD VR events
for i=1:length(fieldnames(epochs.vrevents))
    fn=fieldnames(epochs.vrevents);
    for z=1:length(epocheventtypes)
        temp_data=epochs.vrevents.(fn{i}).(epocheventtypes{z}).val;
        for q=1:length(temp_data)
            [epochs.vrevents.(fn{i}).(epocheventtypes{z}).psd.saw(:,:,q),epochs.vrevents.(fn{i}).(epocheventtypes{z}).psd.freq]=pwelch(trialData.eeg.data(temp_data(q,1):temp_data(q,2),chan_num),1024,[],[],1024);
        end
    end
end

% Find frequency indexes
% delta      1-4 Hz
% theta      4-8 Hz
% alpha      8-12 Hz
% beta       13-30 Hz
% gamma_low  30-50 Hz
% gamma_bb   70-200 Hz

freq_idx_200=find(epochs.vrwhole.psd.freq==200);
freq_idx_delta=find(epochs.vrwhole.psd.freq==1|epochs.vrwhole.psd.freq==4);
freq_idx_theta=find(epochs.vrwhole.psd.freq==4|epochs.vrwhole.psd.freq==8);
freq_idx_alpha=find(epochs.vrwhole.psd.freq==8|epochs.vrwhole.psd.freq==12);
freq_idx_beta=find(epochs.vrwhole.psd.freq==13|epochs.vrwhole.psd.freq==30);
freq_idx_gammal=find(epochs.vrwhole.psd.freq==30|epochs.vrwhole.psd.freq==50);
freq_idx_gammabb=find(epochs.vrwhole.psd.freq==70|epochs.vrwhole.psd.freq==200);

%% Figure Creation (Rest Epochs vs VR Whole Epochs)
%%%%%%%%%%%% Power Spectral Density Analysis (all channels per epoch)[psd_allepoch_allchan] %%%%%%%%%%%% 

psd_vrwhole_allchan_folder=fullfile(restvrfolder,'psd_vrwhole_allchan');
mkdir(psd_vrwhole_allchan_folder);

% Plot VR whole
for i=1:size(epochs.vrwhole.psd.saw,3)

    figure('Name',[trial_label{i},'_VR_whole==',figtitle],'units','normalized','outerposition',[0 0 1 1])
    hold on
    subplot(2,1,1)
    plot(epochs.vrwhole.psd.freq(1:freq_idx_200),log10(epochs.vrwhole.psd.saw(1:freq_idx_200,chan_num,i)),'LineWidth',1.5)
    ylabel('log power')
    xlabel('Hz')
    legend
    title(trial_label{i})
    hold off

    subplot(2,1,2)
    hold on
    plot(epochs.vrwhole.psd.freq(1:freq_idx_200),log10(epochs.vrwhole.psd.saw(1:freq_idx_200,7,i)),'LineWidth',1.5)
    plot(epochs.vrwhole.psd.freq(1:freq_idx_200),log10(epochs.vrwhole.psd.saw(1:freq_idx_200,18,i)),'LineWidth',1.5)
    ylabel('log power')
    xlabel('Hz')
    legend('Channel 7 (C3)','Channel 18(C4)')
    ylim([-4 4]);
    hold off
    
    saveas(gcf,fullfile(psd_vrwhole_allchan_folder,[get(gcf,'Name'),'.jpg']))
end        

close all

%%%%%%%%%%%%%  Power Spectral Density Analysis (rest vs movement) %%%%%%%%%%%% 

% Create reference figure
figure('Name',figtitle,'units','normalized','outerposition',[0 0 1 1]); 
hold on
plot((trialData.eeg.data(:,7)-mean(trialData.eeg.data(:,7)))/std(trialData.eeg.data(:,7)))
plot((trialData.eeg.data(:,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18))-10)
plot((trialData.eeg.data(:,23)-mean(trialData.eeg.data(:,23)))/std(trialData.eeg.data(:,23))-20)
plot((trialData.eeg.data(:,sessioninfo.vrchan)-mean(trialData.eeg.data(:,sessioninfo.vrchan)))/std(trialData.eeg.data(:,sessioninfo.vrchan))-30)
plot(((trialData.eeg.data(:,sessioninfo.tdcschan)-mean(trialData.eeg.data(:,sessioninfo.tdcschan)))/std(trialData.eeg.data(:,sessioninfo.tdcschan))*-1)-40,'LineWidth',2)
xlim([Session_times{1} Session_times{2}]);
yplotlim=get(gca,'ylim');
for i=1:length(epochs.rest.val)
    h1=plot([epochs.rest.val(i,1) epochs.rest.val(i,1)],yplotlim,'-g','LineWidth',2);
    plot([epochs.rest.val(i,2) epochs.rest.val(i,2)],yplotlim,'-r','LineWidth',2);
    text(mean([epochs.rest.val(i,1) epochs.rest.val(i,2)]),yplotlim(2)*0.9,["Rest Epoch",num2str(i)],'HorizontalAlign','Center')
end
for i=1:length(epochs.vrwhole.val)
    h2=plot([epochs.vrwhole.val(i,1) epochs.vrwhole.val(i,1)],yplotlim,'-.g','LineWidth',1);
    plot([epochs.vrwhole.val(i,2) epochs.vrwhole.val(i,2)],yplotlim,'-.r','LineWidth',1);
    text(mean([epochs.vrwhole.val(i,1) epochs.vrwhole.val(i,2)]),yplotlim(2)*0.9,["VR Epoch",num2str(i)],'HorizontalAlign','Center')
end
legend('C3','C4','EKG','VR','tDCS')

% Input Comparison (Rest vs VR Whole Epochs)
% 7- [1,1;2,2;3,3;5,4;5,5;6,6]
% 10- [1,1;2,2;3,3;4,4;5,5]

clc
Epochcompare=input(sprintf('Enter epoch comparisons (Multiple=[#R,#VR;#R,#VR]) :  '))
badtrials=input(sprintf('Any bad trials? (Multiple=[#R,#VR;#R,#VR]) :  '))

% Create Line Plots (Rest Epochs and VR Whole Epochs)
figure('Name',['Cn7_Cn18_RestEpochs==',figtitle],'units','normalized','outerposition',[0 0 1 1])
subplot(1,2,1)
hold on
for i=1:length(Epochcompare)
    plot(epochs.rest.psd.freq(1:freq_idx_200),log10(epochs.rest.psd.saw(1:freq_idx_200,7,Epochcompare(i,1))),'LineWidth',1.5)
end
title('Channel 7 (C3)')
ylim([-4,4])
xlim([0,200])
yplotlim=get(gca,'ylim');
plot([4,4],[yplotlim(1) yplotlim(2)],'b');
plot([8,8],[yplotlim(1) yplotlim(2)],'b');
plot([13,13],[yplotlim(1) yplotlim(2)],'b');
plot([30,30],[yplotlim(1) yplotlim(2)],'b');
plot([50,50],[yplotlim(1) yplotlim(2)],'b');
text(2,3,'D','FontSize',7)
text(6,3,'T','FontSize',7)
text(10.5,3,'A','FontSize',7)
text(21.5,3,'B','FontSize',7)
text(40,3,'G-L','FontSize',7)
text(60,3,'G-bb','FontSize',7)
legend(trial_label)
xlabel('Hz')
ylabel('Log Power')
subplot(1,2,2)
hold on
for i=1:length(Epochcompare)
    plot(epochs.rest.psd.freq(1:freq_idx_200),log10(epochs.rest.psd.saw(1:freq_idx_200,18,Epochcompare(i,1))),'LineWidth',1.5)
end
title('Channel 18 (C4)')
ylim([-4,4])
xlim([0,200])
yplotlim=get(gca,'ylim');
plot([4,4],[yplotlim(1) yplotlim(2)],'b');
plot([8,8],[yplotlim(1) yplotlim(2)],'b');
plot([13,13],[yplotlim(1) yplotlim(2)],'b');
plot([30,30],[yplotlim(1) yplotlim(2)],'b');
plot([50,50],[yplotlim(1) yplotlim(2)],'b');
text(2,3,'D','FontSize',7)
text(6,3,'T','FontSize',7)
text(10.5,3,'A','FontSize',7)
text(21.5,3,'B','FontSize',7)
text(40,3,'G-L','FontSize',7)
text(60,3,'G-bb','FontSize',7)
legend(trial_label)
xlabel('Hz')
ylabel('Log Power')
sgtitle('Rest Epochs')
saveas(gcf,fullfile(restvrfolder,[get(gcf,'Name'),'.jpg']))

figure('Name',['Cn7_Cn18_VRwholeEpochs==',figtitle],'units','normalized','outerposition',[0 0 1 1])
set(gcf,'Position',[111 75 1000 500]);
subplot(1,2,1)
hold on
for i=1:length(Epochcompare)
    plot(epochs.vrwhole.psd.freq(1:freq_idx_200),log10(epochs.vrwhole.psd.saw(1:freq_idx_200,7,Epochcompare(i,2))),'LineWidth',1.5)
end
title('Channel 7 (C3)')
ylim([-4,4])
xlim([0,200])
yplotlim=get(gca,'ylim');
plot([4,4],[yplotlim(1) yplotlim(2)],'b');
plot([8,8],[yplotlim(1) yplotlim(2)],'b');
plot([13,13],[yplotlim(1) yplotlim(2)],'b');
plot([30,30],[yplotlim(1) yplotlim(2)],'b');
plot([50,50],[yplotlim(1) yplotlim(2)],'b');
text(2,3,'D','FontSize',7)
text(6,3,'T','FontSize',7)
text(10.5,3,'A','FontSize',7)
text(21.5,3,'B','FontSize',7)
text(40,3,'G-L','FontSize',7)
text(60,3,'G-bb','FontSize',7)
legend(trial_label)
xlabel('Hz')
ylabel('Log Power')
subplot(1,2,2)
hold on
for i=1:length(Epochcompare)
    plot(epochs.vrwhole.psd.freq(1:freq_idx_200),log10(epochs.vrwhole.psd.saw(1:freq_idx_200,18,Epochcompare(i,2))),'LineWidth',1.5)
end
title('Channel 18 (C4)')
ylim([-4,4])
xlim([0,200])
yplotlim=get(gca,'ylim');
plot([4,4],[yplotlim(1) yplotlim(2)],'b');
plot([8,8],[yplotlim(1) yplotlim(2)],'b');
plot([13,13],[yplotlim(1) yplotlim(2)],'b');
plot([30,30],[yplotlim(1) yplotlim(2)],'b');
plot([50,50],[yplotlim(1) yplotlim(2)],'b');
text(2,3,'D','FontSize',7)
text(6,3,'T','FontSize',7)
text(10.5,3,'A','FontSize',7)
text(21.5,3,'B','FontSize',7)
text(40,3,'G-L','FontSize',7)
text(60,3,'G-bb','FontSize',7)
legend(trial_label)
xlabel('Hz')
ylabel('Log Power')
sgtitle('VR Whole Epochs')
saveas(gcf,fullfile(restvrfolder,[get(gcf,'Name'),'.jpg']))


% Create Beta Bar Graphs (Rest Epochs and VR Whole Epochs)
Epochcompare_total=(Epochcompare');
Epochcompare_total=Epochcompare_total(:);
bar_trial=[];
bar_trial_xlabel=[];
bar_trial_color=[];
for j=1:length(Epochcompare_total)
    switch rem(j,2)
        case 1
                bar_trial{1,j}=(epochs.rest.psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,Epochcompare_total(j)));
                bar_trial{2,j}=(epochs.rest.psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,Epochcompare_total(j)));
                bar_trial_xlabel{1,j}=[trial_label{Epochcompare_total(j)} '\newlineRest' ];
                bar_trial_color{1,j}=[1, 0, 0];
        case 0
                bar_trial{1,j}=(epochs.vrwhole.psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,Epochcompare_total(j)));
                bar_trial{2,j}=(epochs.vrwhole.psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,Epochcompare_total(j)));
                bar_trial_xlabel{1,j}=[trial_label{Epochcompare_total(j)} '\newlineVR Whole' ];
                bar_trial_color{1,j}=[1, 0, 0];
    end
end
bar_data=cellfun(@mean,bar_trial)';

figure('Name',['Beta Bar Graph- Rest vs VR whole==',figtitle],'units','normalized','outerposition',[0 0 1 1])
subplot(2,2,1:2)
h1=bar(bar_data);
set(gca,'XTickLabel',bar_trial_xlabel);
ylabel('Beta Power')
ylim_num=get(gca,'YLim');
xlim_num=get(gca,'XLim');
trial_label_ypoints=[xlim_num(1):diff(xlim_num)/numel(trial_label):xlim_num(2)];
hold on
for i=1:numel(trial_label_ypoints)
    plot([trial_label_ypoints(i) trial_label_ypoints(i)],ylim_num,'--b')
end
legend({'Channel 7(C3)','Channel 18(C4)'})
subplot(2,2,3)
h2=bar(bar_data(1:2:length(bar_data),:));
title('Rest')
ylabel('Beta Power')
set(gca,'XTickLabel',trial_label)
set(gca,'YLim',ylim_num)
subplot(2,2,4)
h3=bar(bar_data(2:2:length(bar_data),:));
ylabel('Beta Power')
title('VR')
set(gca,'XTickLabel',trial_label)
set(gca,'YLim',ylim_num)
saveas(gcf,fullfile(restvrfolder,[get(gcf,'Name'),'.jpg']))

figure('Name',['Beta Bar Graph- Rest vs VR whole- per channel==',figtitle],'units','normalized','outerposition',[0 0 1 1])
subplot(2,1,1)
h1=bar(bar_data(:,1),'FaceColor','flat');
ylabel('Beta Power')
set(gca,'XTickLabel',bar_trial_xlabel);
set(gca,'YLim',ylim_num)
title('Channel 7(C3)')
for i=1:length(bar_data)
    switch rem(i,2)
        case 1
            h1(1).CData(i,:)=[1 0 0];
        case 0
            h1(1).CData(i,:)=[0 1 0];
    end
end
hold on
for i=1:numel(trial_label_ypoints)
    plot([trial_label_ypoints(i) trial_label_ypoints(i)],ylim_num,'--b')
end
hBB=bar(nan(2,2));
hBB(1).FaceColor=[1 0 0]; 
hBB(2).FaceColor=[0 1 0];
legend(hBB,'Rest','VR');
subplot(2,1,2)
h2=bar(bar_data(:,2),'FaceColor','flat');
for i=1:length(bar_data)
    switch rem(i,2)
        case 1
            h2(1).CData(i,:)=[1 0 0];
        case 0
            h2(1).CData(i,:)=[0 1 0];
    end
end
ylabel('Beta Power')
set(gca,'XTickLabel',bar_trial_xlabel);
set(gca,'YLim',ylim_num)
title('Channel 18(C4)')
hold on
for i=1:numel(trial_label_ypoints)
    plot([trial_label_ypoints(i) trial_label_ypoints(i)],ylim_num,'--b')
end
hBB=bar(nan(2,2));
hBB(1).FaceColor=[1 0 0]; 
hBB(2).FaceColor=[0 1 0];
legend(hBB,'Rest','VR');
saveas(gcf,fullfile(restvrfolder,[get(gcf,'Name'),'.jpg']))

%% Figure Creation (Rest Epochs vs VR Event Epochs)

% PSD VR event per trial
psd_vrevent_folder=fullfile(vrepochfolder,'psd_vrevent');
mkdir(psd_vrevent_folder);

for t=1:length(fieldnames(epochs.vrevents))
    figure('Name',[trial_label{t} '-VR events==',figtitle],'units','normalized','outerposition',[0 0 1 1])
    for q=1:numel(epocheventtypes)
        tempdata=epochs.vrevents.(['t',num2str(t)]).(epocheventtypes{q}).psd;
        
        subplot(3,1,q)
        hold on
        plot(tempdata.freq(1:freq_idx_200),log(mean(tempdata.saw(1:freq_idx_200,7,:),3)),'LineWidth',2)
        plot(tempdata.freq(1:freq_idx_200),log(mean(tempdata.saw(1:freq_idx_200,18,:),3)),'LineWidth',2)
        ylabel('log power')
        xlabel('Hz')
        ylim([-4 4]);
        yplotlim=get(gca,'ylim');
        plot([4,4],[yplotlim(1) yplotlim(2)],'b');
        plot([8,8],[yplotlim(1) yplotlim(2)],'b');
        plot([13,13],[yplotlim(1) yplotlim(2)],'b');
        plot([30,30],[yplotlim(1) yplotlim(2)],'b');
        plot([50,50],[yplotlim(1) yplotlim(2)],'b');
        text(2,3,'D','FontSize',7)
        text(6,3,'T','FontSize',7)
        text(10.5,3,'A','FontSize',7)
        text(21.5,3,'B','FontSize',7)
        text(40,3,'G-L','FontSize',7)
        text(60,3,'G-bb','FontSize',7)
        legend({'Channel 7 (C3)','Channel 18 (C4)'})
        title(epocheventlabels{q})
    end
    sgtitle(trial_label{t})
    saveas(gcf,fullfile(psd_vrevent_folder,[get(gcf,'Name'),'.jpg']))
end 

% PSD VR event all trial
figure('Name',['Channel 7 v 18 VR trials-Line plot==',figtitle],'units','normalized','outerposition',[0 0 1 1])
for q=1:numel(epocheventtypes)
    for t=1:length(fieldnames(epochs.vrevents)) 
        tempdata=epochs.vrevents.(['t',num2str(t)]).(epocheventtypes{q}).psd;
        
        subplot(3,2,q+(q-1))
        hold on
        plot(tempdata.freq(1:freq_idx_200),log(mean(tempdata.saw(1:freq_idx_200,7,:),3)),'LineWidth',2);
        title(['Channel 7 (C3)-' epocheventlabels{q}])
        ylim([-4 6])
        xlabel('Hz')
        ylabel('Log Power')
        
        subplot(3,2,q+1+(q-1))
        hold on
        plot(tempdata.freq(1:freq_idx_200),log(mean(tempdata.saw(1:freq_idx_200,18,:),3)),'LineWidth',2);
        title(['Channel 18 (C4)-' epocheventlabels{q}])
        ylim([-4 6])
        xlabel('Hz')
        ylabel('Log Power')
    end
    subplot(3,2,q+(q-1))
    legend(trial_label)
    subplot(3,2,q+1+(q-1))
    legend(trial_label)
end 
saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))
% %% 
% % PSD VR events Bar
% figure('Name',['Beta Bar Graph-VR events==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% subplot(1,2,1)
% bar_dat_cn7=[];
% for i=1:length(Epochcompare)
%     bar_dat_cn7{i,1}=mean(epochs.rest.psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,Epochcompare(i,1)));
%     for z=1:length(epocheventtypes)
%         bar_dat_cn7{i,z+1}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,:),[1 3 2]),1);
%     end
% end
% temp_data=bar_dat_cn7;
% beta_bar=cell2mat(cellfun(@mean,bar_dat_cn7,'UniformOutput',false));
% b1=bar(beta_bar);
% hold on
% err=err_bar(b1,temp_data,beta_bar);
% stats=[];
% for i=1:size(temp_data,1)
%     stats{i}=paired_sigtest(gca,temp_data(i,2:end),beta_bar(i,2:end),err.data(i,2:end),err.location(2:end,i));
% end
% hold on
% title('Channel 7(C3)')
% xlabel('Trials')
% ylabel('Beta Power')
% ylim([0 40])
% n_nums=[];
% for i=1:length(Epochcompare)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),temp_data(i,:))),'\newline', trial_label{Epochcompare(i,2)}];
% end
% set(gca,'XTickLabel',n_nums);
% grid on
% grid minor
% legend('Rest','Hold','Cue','Move')
% 
% subplot(1,2,2)
% bar_dat_cn18=[];
% for i=1:length(Epochcompare)
%     bar_dat_cn18{i,1}=mean(epochs.rest.psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,Epochcompare(i,1)));
%     for z=1:length(epocheventtypes)
%         bar_dat_cn18{i,z+1}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,:),[1 3 2]),1);
%     end
% end
% temp_data=bar_dat_cn18;
% beta_bar=cell2mat(cellfun(@mean,bar_dat_cn18,'UniformOutput',false));
% b1=bar(beta_bar);
% hold on
% err=err_bar(b1,temp_data,beta_bar);
% stats=[];
% for i=2:size(temp_data,1)
%     stats{i}=sigtest(gca,temp_data(i,2:end),beta_bar(i,2:end),err.data(i,2:end),err.location(2:end,i));
% end
% hold on
% title('Channel 18(C4)')
% xlabel('Trials')
% ylabel('Beta Power')
% ylim([0 40])
% n_nums=[];
% for i=1:length(Epochcompare)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),temp_data(i,:))),'\newline', trial_label{Epochcompare(i,2)}];
% end
% set(gca,'XTickLabel',n_nums);
% grid on
% grid minor
% legend('Rest','Hold','Cue','Move')
% saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))
% 
% %% Baseline Beta VR phases
% figure('Name',['Beta Bar VR Phases==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% subplot(1,2,1)
% bar_dat_cn7=[];
% for i=1:length(Epochcompare)
%     bar_dat_cn7{i,1}=mean(epochs.rest.psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,Epochcompare(i,1)));
%     for z=1:length(epocheventtypes)
%         bar_dat_cn7{i,z+1}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,:),[1 3 2]),1);
%     end
% end
% temp_data=bar_dat_cn7';
% beta_bar=cell2mat(cellfun(@mean,temp_data,'UniformOutput',false));
% b1=bar(beta_bar);
% hold on
% err=err_bar(b1,temp_data,beta_bar);
% stats=[];
% for i=2:size(temp_data,1)
%     stats{i}=sigtest(gca,temp_data(i,:),beta_bar(i,:),err.data(i,:),err.location(:,i));
% end
% title('Channel 7(C3)')
% xlabel('Phases')
% ylabel('Beta Power')
% x_tick={'Rest','Hold','Prep','Move'};
% n_nums=[];
% for i=1:numel(x_tick)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),temp_data(i,:))),'\newline', x_tick{i}];
% end
% set(gca,'XTickLabel',n_nums);
% legend(trial_label{Epochcompare(:,2)})
% grid on
% grid minor
% subplot(1,2,2)
% bar_dat_cn18=[];
% for i=1:length(Epochcompare)
%     bar_dat_cn18{i,1}=mean(epochs.rest.psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,Epochcompare(i,1)));
%     for z=1:length(epocheventtypes)
%         bar_dat_cn18{i,z+1}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,:),[1 3 2]),1);
%     end
% end
% temp_data=bar_dat_cn18';
% beta_bar=cell2mat(cellfun(@mean,temp_data,'UniformOutput',false));
% b1=bar(beta_bar);
% hold on
% err=err_bar(b1,temp_data,beta_bar);
% stats=[];
% for i=2:size(temp_data,1)
%     stats{i}=sigtest(gca,temp_data(i,:),beta_bar(i,:),err.data(i,:),err.location(:,i));
% end
% title('Channel 18(C4)')
% xlabel('Phases')
% ylabel('Beta Power')
% n_nums=[];
% for i=1:numel(x_tick)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),temp_data(i,:))),'\newline', x_tick{i}];
% end
% set(gca,'XTickLabel',n_nums);
% legend(trial_label{Epochcompare(:,2)})
% grid on
% grid minor

% saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))
% 
% %% Beta Difference
% figure('Name',['Beta Bar Graph Difference-VR events==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% bar_dat_cn7=[];
% for i=1:length(Epochcompare)
%     for z=1:length(epocheventtypes)
%         bar_dat_cn7{i,z}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,:),[1 3 2]),1);
%     end
% end
% bar_dat_cn7_diff=[];
% for i=1:size(bar_dat_cn7,1)
%     bar_dat_cn7_diff{i,1}=diff([bar_dat_cn7{i,1}; bar_dat_cn7{i,2}],1,1);
%     bar_dat_cn7_diff{i,2}=diff([bar_dat_cn7{i,2}; bar_dat_cn7{i,3}],1,1);
% end
% 
% subplot(2,2,1)
% tempdata=bar_dat_cn7_diff(:,1);
% beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% b1=bar(beta_bar_mean);
% hold on
% err=err_bar(b1,tempdata,beta_bar_mean);
% sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% title('Hold-Prep (Cn7)')
% xlabel('Trials')
% ylabel('Beta Power Difference')
% n_nums=[];
% for i=1:length(Epochcompare)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% end
% set(gca,'XTickLabel',n_nums);
% grid on
% grid minor
% 
% subplot(2,2,2)
% tempdata=bar_dat_cn7_diff(:,2);
% beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% b1=bar(beta_bar_mean);
% hold on
% err=err_bar(b1,tempdata,beta_bar_mean);
% sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% title('Prep-Move(Cn7)')
% xlabel('Trials')
% ylabel('Beta Power Difference')
% n_nums=[];
% for i=1:length(Epochcompare)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% end
% set(gca,'XTickLabel',n_nums);
% grid on
% grid minor
% 
% subplot(2,2,3)
% bar_dat_cn18=[];
% for i=1:size(Epochcompare,1)
%     for z=1:length(epocheventtypes)
%         bar_dat_cn18{i,z}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,:),[1 3 2]),1);
%     end
% end
% bar_dat_cn18_diff=[];
% for i=1:size(bar_dat_cn18,1)
%     bar_dat_cn18_diff{i,1}=diff([bar_dat_cn18{i,1}; bar_dat_cn18{i,2}],1,1);
%     bar_dat_cn18_diff{i,2}=diff([bar_dat_cn18{i,2}; bar_dat_cn18{i,3}],1,1);
% end
% tempdata=bar_dat_cn18_diff(:,1);
% beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% b1=bar(beta_bar_mean);
% hold on
% err=err_bar(b1,tempdata,beta_bar_mean);
% sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% title('Hold-Prep (Cn18)')
% xlabel('Trials')
% ylabel('Beta Power Difference')
% n_nums=[];
% n_nums=[];
% for i=1:length(Epochcompare)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% end
% set(gca,'XTickLabel',n_nums);
% grid on
% grid minor
% 
% subplot(2,2,4)
% tempdata=bar_dat_cn18_diff(:,2);
% beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% b1=bar(beta_bar_mean);
% hold on
% err=err_bar(b1,tempdata,beta_bar_mean);
% sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% title('Prep-Move(Cn18)')
% xlabel('Trials')
% ylabel('Beta Power Difference')
% n_nums=[];
% for i=1:size(Epochcompare,2)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% end
% set(gca,'XTickLabel',n_nums);
% grid on
% grid minor
% saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))
% 
% 
% figure('Name',['Beta Bar Graph Percent Difference-VR events==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% bar_dat_cn7=[];
% for i=1:size(Epochcompare,1)
%     for z=1:length(epocheventtypes)
%         bar_dat_cn7{i,z}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,:),[1 3 2]),1);
%     end
% end
% bar_dat_cn7_diff=[];
% for i=1:size(bar_dat_cn7,1)
%     bar_dat_cn7_diff{i,1}=diff([bar_dat_cn7{i,1}; bar_dat_cn7{i,2}],1,1)./bar_dat_cn7{i,1};
%     bar_dat_cn7_diff{i,2}=diff([bar_dat_cn7{i,2}; bar_dat_cn7{i,3}],1,1)./bar_dat_cn7{i,2};
% end
% 
% subplot(2,2,1)
% tempdata=bar_dat_cn7_diff(:,1);
% beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% b1=bar(beta_bar_mean);
% hold on
% err=err_bar(b1,tempdata,beta_bar_mean);
% sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% title('Hold-Prep (Cn7)')
% xlabel('Trials')
% ylabel('Beta Power % Difference')
% n_nums=[];
% for i=1:size(Epochcompare,1)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% end
% set(gca,'XTickLabel',n_nums);
% grid on
% grid minor
% 
% subplot(2,2,2)
% tempdata=bar_dat_cn7_diff(:,2);
% beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% b1=bar(beta_bar_mean);
% hold on
% err=err_bar(b1,tempdata,beta_bar_mean);
% sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% title('Prep-Move(Cn7)')
% xlabel('Trials')
% ylabel('Beta Power % Difference')
% n_nums=[];
% for i=1:length(Epochcompare)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% end
% set(gca,'XTickLabel',n_nums);
% grid on
% grid minor
% 
% subplot(2,2,3)
% bar_dat_cn18=[];
% for i=1:length(Epochcompare)
%     for z=1:length(epocheventtypes)
%         bar_dat_cn18{i,z}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,:),[1 3 2]),1);
%     end
% end
% bar_dat_cn18_diff=[];
% for i=1:size(bar_dat_cn18,1)
%     bar_dat_cn18_diff{i,1}=diff([bar_dat_cn18{i,1}; bar_dat_cn18{i,2}],1,1)./bar_dat_cn18{i,1};
%     bar_dat_cn18_diff{i,2}=diff([bar_dat_cn18{i,2}; bar_dat_cn18{i,3}],1,1)./bar_dat_cn18{i,2};
% end
% tempdata=bar_dat_cn18_diff(:,1);
% beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% b1=bar(beta_bar_mean);
% hold on
% err=err_bar(b1,tempdata,beta_bar_mean);
% sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% title('Hold-Prep (Cn18)')
% xlabel('Trials')
% ylabel('Beta Power % Difference')
% n_nums=[];
% n_nums=[];
% for i=1:length(Epochcompare)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% end
% set(gca,'XTickLabel',n_nums);
% grid on
% grid minor
% 
% subplot(2,2,4)
% tempdata=bar_dat_cn18_diff(:,2);
% beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% b1=bar(beta_bar_mean);
% hold on
% err=err_bar(b1,tempdata,beta_bar_mean);
% sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% title('Prep-Move(Cn18)')
% xlabel('Trials')
% ylabel('Beta Power % Difference')
% n_nums=[];
% for i=1:length(Epochcompare)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% end
% set(gca,'XTickLabel',n_nums);
% grid on
% grid minor
% saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))
% 
% figure('Name',['Beta Reactivity ratio==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% switch sessioninfo.stimlat
%     case 'R'
%         stim_side=bar_dat_cn18_diff;
%         nonstim_side=bar_dat_cn7_diff;
%     case 'L'
%         nonstim_side=bar_dat_cn18_diff;
%         stim_side=bar_dat_cn7_diff;
% end
% subplot(1,2,1)
% rr=cell(length(stim_side),1);
% for i=1:length(rr)
%     rr{i}=stim_side{i,1}./nonstim_side{i,1};
% end
% b1=bar(cellfun(@mean,rr));
% hold on
% err=err_bar(b1,rr,cellfun(@mean,rr));
% sigtest(gca,rr',cellfun(@mean,rr),err.data,err.location);
% xlabel('Trials')
% ylabel('Beta Reactivity Ratio')
% title('Hold to Prep Beta Reactivity Ratio')
% n_nums=[];
% for i=1:length(Epochcompare)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% end
% set(gca,'XTickLabel',n_nums,'XTickLabelRotation',30);
% 
% subplot(1,2,2)
% rr=cell(length(stim_side),1);
% for i=1:length(rr)
%     rr{i}=stim_side{i,2}./nonstim_side{i,2};
% end
% b1=bar(cellfun(@mean,rr));
% hold on
% err=err_bar(b1,rr,cellfun(@mean,rr));
% sigtest(gca,rr',cellfun(@mean,rr),err.data,err.location);
% xlabel('Trials')
% ylabel('Beta Reactivity Ratio')
% title('Prep to Move Beta Reactivity Ratio')
% n_nums=[];
% for i=1:length(Epochcompare)
%     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% end
% set(gca,'XTickLabel',n_nums,'XTickLabelRotation',30);
% saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))

%% Save variables
% Remove bad trials
fn=fieldnames(epochs.vrevents);
for bt=1:size(badtrials,1)
    epochs.vrevents=rmfield(epochs.vrevents,(fn{bt}));
end

save(fullfile(eeganalysisfolder,'s3_dat_simple'),'Epochcompare','epochs','badtrials')
end