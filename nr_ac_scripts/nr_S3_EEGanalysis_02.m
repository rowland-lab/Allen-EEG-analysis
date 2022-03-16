function nr_S3_EEGanalysis_02(sbjnum,protocolfolder)
%% Define variables and import data
analysisfolder=fullfile(protocolfolder,sbjnum,'analysis');

% Detect and import S1 info file
try
    disp('Importing S1 files');
    importdataS1=load(fullfile(analysisfolder,'S1-VR_preproc',[sbjnum,'_S1-VRdata_preprocessed.mat']));
catch
    error('Step 1 Preprocessing files NOT FOUND')
end
sessioninfo=importdataS1.sessioninfo;
trialData=importdataS1.trialData;


% Detect and import S2 file
try
    disp('Importing S2 files');
    importdataS2=load(fullfile(analysisfolder,'S2-metrics',[sbjnum,'_S2-Metrics']));
catch
    error('Step 2 Preprocessing files NOT FOUND')
end
S2_trialdat=importdataS2.trialData.vr;
movementstart=struct2cell(importdataS2.movementstart);
movementstart=[movementstart{:}];

% Replace VR trials with preproc VR trials
trialData.vr=S2_trialdat;

% Define folders
edffile=sessioninfo.path.edffile;
vrDataFolder=sessioninfo.path.vrfolder;
eeganalysisfolder=fullfile(analysisfolder,'S3-EEGanalysis');

% Make eeg analysis folder
mkdir(eeganalysisfolder)

% Make restvr folder
restvrfolder=fullfile(eeganalysisfolder,'restvr');
mkdir(restvrfolder)

% Make vrepoch folder
vrepochfolder=fullfile(eeganalysisfolder,'vrepoch');
mkdir(vrepochfolder)

trial_label=sessioninfo.trialnames;
figtitle=[sessioninfo.patientID,'-',sessioninfo.dx,'-',sessioninfo.stimlat];

if strcmp(sessioninfo.stimlat,'R')
    stim_cn=18;
    contra_cn=7;
else
    stim_cn=7;
    contra_cn=18;
end



%%%%%%%%%%%%%%%%%% Applying Filters %%%%%%%%%%%%%%%%%%%%
disp('Applying Filter');
% Alternating current filter
[n1_b, n1_a]=butter(3,2*[57 63]/trialData.eeg.header.samplingrate,'stop');%60 Hz
[n2_b, n2_a]=butter(3,2*[117 123]/trialData.eeg.header.samplingrate,'stop');%120 Hz
% [n3_b, n3_a]=butter(3,2*[177 183]/trialData.eeg.header.samplingrate,'stop');%180 Hz

trialData.eeg.data=filtfilt(n1_b,n1_a,trialData.eeg.data);
trialData.eeg.data=filtfilt(n2_b,n2_a,trialData.eeg.data);
% trialData.eeg.data=filtfilt(n3_b,n3_a,trialData.eeg.data);


% % Band pass filter
% trialData.eeg.data(:,1:22)= bandpass(trialData.eeg.data(:,1:22),[13 30],trialData.eeg.header.samplingrate);




%% Epochs (Movement, Rest)

% Epoch length in seconds
epochlength=60;
buffer=1;

% Channel Number
chan_num=1:22;

% Sample Frequency
fs=trialData.eeg.header.samplingrate;

Session_times= sessioninfo.sessionperiod;
VR_sig=sessioninfo.vrsig;


clc
x=2;
close all

while x~=1
    % Epoch VR whole trials
    epochs.vrwhole.val(:,1)=mean(VR_sig(:,1:2),2)-((epochlength*trialData.eeg.header.samplingrate)/2);
    epochs.vrwhole.val(:,2)=mean(VR_sig(:,1:2),2)+((epochlength*trialData.eeg.header.samplingrate)/2);

    % Epoch Rest trials
    for i=1:length(VR_sig)
        if i==1
            epochs.rest.val(i,1)=VR_sig(i,1)-(buffer*trialData.eeg.header.samplingrate)-(epochlength*trialData.eeg.header.samplingrate);
        end
        epochs.rest.val(i,1)=VR_sig(i,1)-(buffer*trialData.eeg.header.samplingrate)-(epochlength*trialData.eeg.header.samplingrate);
    end
    epochs.rest.val(:,2)=epochs.rest.val(:,1)+(epochlength*trialData.eeg.header.samplingrate);


    % Epoch VR events
    epocheventtypes={'atStartPosition','cueEvent','targetUp'};
    epocheventlabels={'Hold','Prep','Move'};

    min_epochlength=[];
    for i=1:length(trialData.vr)
        for t=1:length(epocheventtypes)
            switch epocheventtypes{t}
                case 'atStartPosition'
                    eval(['epochs.vrevents.t',num2str(i),'.atStartPosition.val=trialData.vr(i).events.',epocheventtypes{t},'.time(:)*trialData.eeg.header.samplingrate;'])
                case 'cueEvent'
                    eval(['epochs.vrevents.t',num2str(i),'.cueEvent.val=trialData.vr(i).events.',epocheventtypes{t},'.time(:)*trialData.eeg.header.samplingrate;'])
                    min_epochlength=[min_epochlength; eval(['epochs.vrevents.t',num2str(i),'.cueEvent.val'])];
                case 'targetUp'
                    eval(['epochs.vrevents.t',num2str(i),'.targetUp.val=trialData.vr(i).events.',epocheventtypes{t},'.time(:)*trialData.eeg.header.samplingrate;'])
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
    figure('Name',['Epoched EEG signal graph==',figtitle]); set(gcf,'Position',[36 57 1415 871]) 
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
                    text(eventtimes(q)*fs,0,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q)],'FontSize',11,'Rotation',-90)
                else
                    text(eventtimes(q)*fs,0,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q)],'FontSize',11,'Rotation',90)
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
    [epochs.vrwhole.psd.saw(:,:,i),epochs.vrwhole.psd.freq]=pwelch(trialData.eeg.data(epochs.vrwhole.val(i,1):epochs.vrwhole.val(i,2),chan_num),fs,[],[],fs);
end

% PSD Rest epochs
for i=1:length(epochs.rest.val)
    [epochs.rest.psd.saw(:,:,i),epochs.rest.psd.freq]=pwelch(trialData.eeg.data(epochs.rest.val(i,1):epochs.rest.val(i,2),chan_num),fs,[],[],fs);
end

% PSD VR events
for i=1:length(fieldnames(epochs.vrevents))
    fn=fieldnames(epochs.vrevents);
    for z=1:length(epocheventtypes)
        temp_data=epochs.vrevents.(fn{i}).(epocheventtypes{z}).val;
        for q=1:length(temp_data)
            [epochs.vrevents.(fn{i}).(epocheventtypes{z}).psd.saw(:,:,q),epochs.vrevents.(fn{i}).(epocheventtypes{z}).psd.freq]=pwelch(trialData.eeg.data(temp_data(q,1):temp_data(q,2),chan_num),[],[],[],fs);
        end
    end
end

% PSD VR event reactivity (-1 sec, +1 sec)
fn=fieldnames(epochs.vrevents);
for t=1:length(fn)
    for ev=1:length(epocheventtypes)
        temp_data=epochs.vrevents.(fn{t}).(epocheventtypes{ev}).val;
        for re=1:length(temp_data)
            [epochs.vrreactivity.(fn{t}).(epocheventtypes{ev}).psd.saw{re,1},epochs.vrreactivity.(fn{t}).(epocheventtypes{ev}).psd.freq{re,1}]=pwelch(trialData.eeg.data(temp_data(re,1)-fs:temp_data(re,1),chan_num),[],[],[],fs);
            [epochs.vrreactivity.(fn{t}).(epocheventtypes{ev}).psd.saw{re,2},epochs.vrreactivity.(fn{t}).(epocheventtypes{ev}).psd.freq{re,2}]=pwelch(trialData.eeg.data(temp_data(re,1):temp_data(re,1)+fs,chan_num),[],[],[],fs);
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

freq_idx_100=find(epochs.vrwhole.psd.freq==100);
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

    figure('Name',[trial_label{i},'_VR_whole==',figtitle]); set(gcf,'Position',[36 57 1415 871])
    hold on
    subplot(2,1,1)
    plot(epochs.vrwhole.psd.freq(1:freq_idx_100),log10(epochs.vrwhole.psd.saw(1:freq_idx_100,chan_num,i)),'LineWidth',1.5)
    ylabel('log power')
    xlabel('Hz')
    legend
    title(trial_label{i})
    hold off

    subplot(2,1,2)
    hold on
    plot(epochs.vrwhole.psd.freq(1:freq_idx_100),log10(epochs.vrwhole.psd.saw(1:freq_idx_100,7,i)),'LineWidth',1.5)
    plot(epochs.vrwhole.psd.freq(1:freq_idx_100),log10(epochs.vrwhole.psd.saw(1:freq_idx_100,18,i)),'LineWidth',1.5)
    ylabel('log power')
    xlabel('Hz')
    legend('Channel 7 (C3)','Channel 18(C4)')
    ylim([-4 4]);
    hold off
    
    saveas(gcf,fullfile(psd_vrwhole_allchan_folder,[get(gcf,'Name'),'.jpg']))
end        

close all

%%%%%%%%%%%%%  Power Spectral Density Analysis (rest vs movement) %%%%%%%%%%%% 

% % Create reference figure
% figure('Name',figtitle,'units','normalized','outerposition',[0 0 1 1]); 
% hold on
% plot((trialData.eeg.data(:,7)-mean(trialData.eeg.data(:,7)))/std(trialData.eeg.data(:,7)))
% plot((trialData.eeg.data(:,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18))-10)
% plot((trialData.eeg.data(:,23)-mean(trialData.eeg.data(:,23)))/std(trialData.eeg.data(:,23))-20)
% plot((trialData.eeg.data(:,sessioninfo.vrchan)-mean(trialData.eeg.data(:,sessioninfo.vrchan)))/std(trialData.eeg.data(:,sessioninfo.vrchan))-30)
% plot(((trialData.eeg.data(:,sessioninfo.tdcschan)-mean(trialData.eeg.data(:,sessioninfo.tdcschan)))/std(trialData.eeg.data(:,sessioninfo.tdcschan))*-1)-40,'LineWidth',2)
% xlim([Session_times{1} Session_times{2}]);
% yplotlim=get(gca,'ylim');
% for i=1:length(epochs.rest.val)
%     h1=plot([epochs.rest.val(i,1) epochs.rest.val(i,1)],yplotlim,'-g','LineWidth',2);
%     plot([epochs.rest.val(i,2) epochs.rest.val(i,2)],yplotlim,'-r','LineWidth',2);
%     text(mean([epochs.rest.val(i,1) epochs.rest.val(i,2)]),yplotlim(2)*0.9,["Rest Epoch",num2str(i)],'HorizontalAlign','Center')
% end
% for i=1:length(epochs.vrwhole.val)
%     h2=plot([epochs.vrwhole.val(i,1) epochs.vrwhole.val(i,1)],yplotlim,'-.g','LineWidth',1);
%     plot([epochs.vrwhole.val(i,2) epochs.vrwhole.val(i,2)],yplotlim,'-.r','LineWidth',1);
%     text(mean([epochs.vrwhole.val(i,1) epochs.vrwhole.val(i,2)]),yplotlim(2)*0.9,["VR Epoch",num2str(i)],'HorizontalAlign','Center')
% end
% legend('C3','C4','EKG','VR','tDCS')
% 
% % Input Comparison (Rest vs VR Whole Epochs)
% clc
% Epochcompare=input(sprintf('Enter epoch comparisons (Multiple=[#R,#VR;#R,#VR]) :  '));
Epochcompare=[1:size(epochs.vrwhole.val,1);1:size(epochs.vrwhole.val,1)]'; % Default epoch compare

% % Create Line Plots (Rest Epochs and VR Whole Epochs)
% figure('Name',['Cn7_Cn18_RestEpochs==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% subplot(1,2,1)
% hold on
% for i=1:length(Epochcompare)
%     plot(epochs.rest.psd.freq(1:freq_idx_100),log10(epochs.rest.psd.saw(1:freq_idx_100,7,Epochcompare(i,1))),'LineWidth',1.5)
% end
% title('Channel 7 (C3)')
% ylim([-4,4])
% xlim([0,200])
% yplotlim=get(gca,'ylim');
% plot([4,4],[yplotlim(1) yplotlim(2)],'b');
% plot([8,8],[yplotlim(1) yplotlim(2)],'b');
% plot([13,13],[yplotlim(1) yplotlim(2)],'b');
% plot([30,30],[yplotlim(1) yplotlim(2)],'b');
% plot([50,50],[yplotlim(1) yplotlim(2)],'b');
% text(2,3,'D','FontSize',7)
% text(6,3,'T','FontSize',7)
% text(10.5,3,'A','FontSize',7)
% text(21.5,3,'B','FontSize',7)
% text(40,3,'G-L','FontSize',7)
% text(60,3,'G-bb','FontSize',7)
% legend(trial_label)
% xlabel('Hz')
% ylabel('Log Power')
% subplot(1,2,2)
% hold on
% for i=1:length(Epochcompare)
%     plot(epochs.rest.psd.freq(1:freq_idx_100),log10(epochs.rest.psd.saw(1:freq_idx_100,18,Epochcompare(i,1))),'LineWidth',1.5)
% end
% title('Channel 18 (C4)')
% ylim([-4,4])
% xlim([0,200])
% yplotlim=get(gca,'ylim');
% plot([4,4],[yplotlim(1) yplotlim(2)],'b');
% plot([8,8],[yplotlim(1) yplotlim(2)],'b');
% plot([13,13],[yplotlim(1) yplotlim(2)],'b');
% plot([30,30],[yplotlim(1) yplotlim(2)],'b');
% plot([50,50],[yplotlim(1) yplotlim(2)],'b');
% text(2,3,'D','FontSize',7)
% text(6,3,'T','FontSize',7)
% text(10.5,3,'A','FontSize',7)
% text(21.5,3,'B','FontSize',7)
% text(40,3,'G-L','FontSize',7)
% text(60,3,'G-bb','FontSize',7)
% legend(trial_label)
% xlabel('Hz')
% ylabel('Log Power')
% sgtitle('Rest Epochs')
% saveas(gcf,fullfile(restvrfolder,[get(gcf,'Name'),'.jpg']))
% 
% figure('Name',['Cn7_Cn18_VRwholeEpochs==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% set(gcf,'Position',[111 75 1000 500]);
% subplot(1,2,1)
% hold on
% for i=1:length(Epochcompare)
%     plot(epochs.vrwhole.psd.freq(1:freq_idx_100),log10(epochs.vrwhole.psd.saw(1:freq_idx_100,7,Epochcompare(i,2))),'LineWidth',1.5)
% end
% title('Channel 7 (C3)')
% ylim([-4,4])
% xlim([0,200])
% yplotlim=get(gca,'ylim');
% plot([4,4],[yplotlim(1) yplotlim(2)],'b');
% plot([8,8],[yplotlim(1) yplotlim(2)],'b');
% plot([13,13],[yplotlim(1) yplotlim(2)],'b');
% plot([30,30],[yplotlim(1) yplotlim(2)],'b');
% plot([50,50],[yplotlim(1) yplotlim(2)],'b');
% text(2,3,'D','FontSize',7)
% text(6,3,'T','FontSize',7)
% text(10.5,3,'A','FontSize',7)
% text(21.5,3,'B','FontSize',7)
% text(40,3,'G-L','FontSize',7)
% text(60,3,'G-bb','FontSize',7)
% legend(trial_label)
% xlabel('Hz')
% ylabel('Log Power')
% subplot(1,2,2)
% hold on
% for i=1:length(Epochcompare)
%     plot(epochs.vrwhole.psd.freq(1:freq_idx_100),log10(epochs.vrwhole.psd.saw(1:freq_idx_100,18,Epochcompare(i,2))),'LineWidth',1.5)
% end
% title('Channel 18 (C4)')
% ylim([-4,4])
% xlim([0,200])
% yplotlim=get(gca,'ylim');
% plot([4,4],[yplotlim(1) yplotlim(2)],'b');
% plot([8,8],[yplotlim(1) yplotlim(2)],'b');
% plot([13,13],[yplotlim(1) yplotlim(2)],'b');
% plot([30,30],[yplotlim(1) yplotlim(2)],'b');
% plot([50,50],[yplotlim(1) yplotlim(2)],'b');
% text(2,3,'D','FontSize',7)
% text(6,3,'T','FontSize',7)
% text(10.5,3,'A','FontSize',7)
% text(21.5,3,'B','FontSize',7)
% text(40,3,'G-L','FontSize',7)
% text(60,3,'G-bb','FontSize',7)
% legend(trial_label)
% xlabel('Hz')
% ylabel('Log Power')
% sgtitle('VR Whole Epochs')
% saveas(gcf,fullfile(restvrfolder,[get(gcf,'Name'),'.jpg']))
% 
% 
% % Create Beta Bar Graphs (Rest Epochs and VR Whole Epochs)
% Epochcompare_total=(Epochcompare');
% Epochcompare_total=Epochcompare_total(:);
% bar_trial=[];
% bar_trial_xlabel=[];
% bar_trial_color=[];
% for j=1:length(Epochcompare_total)
%     switch rem(j,2)
%         case 1
%                 bar_trial{1,j}=(epochs.rest.psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,Epochcompare_total(j)));
%                 bar_trial{2,j}=(epochs.rest.psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,Epochcompare_total(j)));
%                 bar_trial_xlabel{1,j}=[trial_label{Epochcompare_total(j)} '\newlineRest' ];
%                 bar_trial_color{1,j}=[1, 0, 0];
%         case 0
%                 bar_trial{1,j}=(epochs.vrwhole.psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,Epochcompare_total(j)));
%                 bar_trial{2,j}=(epochs.vrwhole.psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,Epochcompare_total(j)));
%                 bar_trial_xlabel{1,j}=[trial_label{Epochcompare_total(j)} '\newlineVR Whole' ];
%                 bar_trial_color{1,j}=[1, 0, 0];
%     end
% end
% bar_data=cellfun(@mean,bar_trial)';
% 
% figure('Name',['Beta Bar Graph- Rest vs VR whole==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% subplot(2,2,1:2)
% h1=bar(bar_data);
% set(gca,'XTickLabel',bar_trial_xlabel);
% ylabel('Beta Power')
% ylim_num=get(gca,'YLim');
% xlim_num=get(gca,'XLim');
% trial_label_ypoints=[xlim_num(1):diff(xlim_num)/numel(trial_label):xlim_num(2)];
% hold on
% for i=1:numel(trial_label_ypoints)
%     plot([trial_label_ypoints(i) trial_label_ypoints(i)],ylim_num,'--b')
% end
% legend({'Channel 7(C3)','Channel 18(C4)'})
% subplot(2,2,3)
% h2=bar(bar_data(1:2:length(bar_data),:));
% title('Rest')
% ylabel('Beta Power')
% set(gca,'XTickLabel',trial_label)
% set(gca,'YLim',ylim_num)
% subplot(2,2,4)
% h3=bar(bar_data(2:2:length(bar_data),:));
% ylabel('Beta Power')
% title('VR')
% set(gca,'XTickLabel',trial_label)
% set(gca,'YLim',ylim_num)
% saveas(gcf,fullfile(restvrfolder,[get(gcf,'Name'),'.jpg']))
% 
% figure('Name',['Beta Bar Graph- Rest vs VR whole- per channel==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% subplot(2,1,1)
% h1=bar(bar_data(:,1),'FaceColor','flat');
% ylabel('Beta Power')
% set(gca,'XTickLabel',bar_trial_xlabel);
% set(gca,'YLim',ylim_num)
% title('Channel 7(C3)')
% for i=1:length(bar_data)
%     switch rem(i,2)
%         case 1
%             h1(1).CData(i,:)=[1 0 0];
%         case 0
%             h1(1).CData(i,:)=[0 1 0];
%     end
% end
% hold on
% for i=1:numel(trial_label_ypoints)
%     plot([trial_label_ypoints(i) trial_label_ypoints(i)],ylim_num,'--b')
% end
% hBB=bar(nan(2,2));
% hBB(1).FaceColor=[1 0 0]; 
% hBB(2).FaceColor=[0 1 0];
% legend(hBB,'Rest','VR');
% subplot(2,1,2)
% h2=bar(bar_data(:,2),'FaceColor','flat');
% for i=1:length(bar_data)
%     switch rem(i,2)
%         case 1
%             h2(1).CData(i,:)=[1 0 0];
%         case 0
%             h2(1).CData(i,:)=[0 1 0];
%     end
% end
% ylabel('Beta Power')
% set(gca,'XTickLabel',bar_trial_xlabel);
% set(gca,'YLim',ylim_num)
% title('Channel 18(C4)')
% hold on
% for i=1:numel(trial_label_ypoints)
%     plot([trial_label_ypoints(i) trial_label_ypoints(i)],ylim_num,'--b')
% end
% hBB=bar(nan(2,2));
% hBB(1).FaceColor=[1 0 0]; 
% hBB(2).FaceColor=[0 1 0];
% legend(hBB,'Rest','VR');
% saveas(gcf,fullfile(restvrfolder,[get(gcf,'Name'),'.jpg']))
% 
% %% Figure Creation (Rest Epochs vs VR Event Epochs)
% 
% % PSD VR event per trial
% psd_vrevent_folder=fullfile(vrepochfolder,'psd_vrevent');
% mkdir(psd_vrevent_folder);
% 
% for t=1:length(fieldnames(epochs.vrevents))
%     figure('Name',[trial_label{t} '-VR events==',figtitle],'units','normalized','outerposition',[0 0 1 1])
%     for q=1:numel(epocheventtypes)
%         tempdata=epochs.vrevents.(['t',num2str(t)]).(epocheventtypes{q}).psd;
%         
%         subplot(3,1,q)
%         hold on
%         plot(tempdata.freq(1:freq_idx_100),log10(mean(tempdata.saw(1:freq_idx_100,7,:),3)),'LineWidth',2)
%         plot(tempdata.freq(1:freq_idx_100),log10(mean(tempdata.saw(1:freq_idx_100,18,:),3)),'LineWidth',2)
%         ylabel('log power')
%         xlabel('Hz')
%         ylim([-4 4]);
%         yplotlim=get(gca,'ylim');
%         plot([4,4],[yplotlim(1) yplotlim(2)],'b');
%         plot([8,8],[yplotlim(1) yplotlim(2)],'b');
%         plot([13,13],[yplotlim(1) yplotlim(2)],'b');
%         plot([30,30],[yplotlim(1) yplotlim(2)],'b');
%         plot([50,50],[yplotlim(1) yplotlim(2)],'b');
%         text(2,3,'D','FontSize',7)
%         text(6,3,'T','FontSize',7)
%         text(10.5,3,'A','FontSize',7)
%         text(21.5,3,'B','FontSize',7)
%         text(40,3,'G-L','FontSize',7)
%         text(60,3,'G-bb','FontSize',7)
%         legend({'Channel 7 (C3)','Channel 18 (C4)'})
%         title(epocheventlabels{q})
%     end
%     sgtitle(trial_label{t})
%     saveas(gcf,fullfile(psd_vrevent_folder,[get(gcf,'Name'),'.jpg']))
% end 
% 
% % PSD VR event all trial
% figure('Name',['Channel 7 v 18 VR trials-Line plot==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% for q=1:numel(epocheventtypes)
%     for t=1:length(fieldnames(epochs.vrevents)) 
%         tempdata=epochs.vrevents.(['t',num2str(t)]).(epocheventtypes{q}).psd;
%         freq_idx_100=find(tempdata.freq<=200,1,'last');
%         subplot(3,2,q+(q-1))
%         hold on
%         plot(tempdata.freq(1:freq_idx_100),log10(mean(tempdata.saw(1:freq_idx_100,7,:),3)),'LineWidth',2);
%         title(['Channel 7 (C3)-' epocheventlabels{q}])
%         ylim([-4 6])
%         xlabel('Hz')
%         ylabel('Log Power')
%         
%         subplot(3,2,q+1+(q-1))
%         hold on
%         plot(tempdata.freq(1:freq_idx_100),log10(mean(tempdata.saw(1:freq_idx_100,18,:),3)),'LineWidth',2);
%         title(['Channel 18 (C4)-' epocheventlabels{q}])
%         ylim([-4 6])
%         xlabel('Hz')
%         ylabel('Log Power')
%     end
%     subplot(3,2,q+(q-1))
%     legend(trial_label)
%     subplot(3,2,q+1+(q-1))
%     legend(trial_label)
% end 
% saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))
% %%
% % Calculate beta power change (Line graph)
% reactivitydata=epochs.vrreactivity;
% fn=fieldnames(reactivitydata);
% epocheventnames={'Hold','Prep','Move'};
% laterality=({'stimside','contraside'});
% for lat=1:numel(laterality)
%     figure('Name',[figtitle,'--beta reactivity-line-',laterality{lat}],'units','normalized','outerposition',[0 0 1 1]);
%     ax=[];
%     for trial=1:numel(fn)
%         tdat=reactivitydata.(fn{trial});
%         for et=1:numel(epocheventtypes)
%             psddat=tdat.(epocheventtypes{et}).psd;
% 
%             sawdat=psddat.saw;
%             freqdat=psddat.freq;
% 
%             for rc=1:size(sawdat,1)
%                 betaidx=freqdat{rc,1}>=13 & freqdat{rc,1}<=30;
% 
%                 betareact.(epocheventtypes{et}).stimside(rc,1)=log(mean(sawdat{rc,1}(betaidx,stim_cn)));
%                 betareact.(epocheventtypes{et}).stimside(rc,2)=log(mean(sawdat{rc,2}(betaidx,stim_cn)));
% 
%                 betareact.(epocheventtypes{et}).contraside(rc,1)=log(mean(sawdat{rc,1}(betaidx,contra_cn)));
%                 betareact.(epocheventtypes{et}).contraside(rc,2)=log(mean(sawdat{rc,2}(betaidx,contra_cn)));
%             end
% 
%             subplot(numel(fn),numel(epocheventtypes),et+(trial-1)*3)
%             hold on
%             tempdat=betareact.(epocheventtypes{et}).(laterality{lat});
%             pl=plot([ones(size(tempdat,1),1) ones(size(tempdat,1),1)*2]',tempdat','-o','LineWidth',1);
%             diffbeta=diff(betareact.(epocheventtypes{et}).(laterality{lat}),1,2);
%             averagediff=mean(diffbeta);
%             negdiff=find(diffbeta<0);
%             for nd=negdiff'
%                 pl(nd).Marker='x';
%                 pl(nd).LineStyle='--';
%             end
%             xlim([0 3])
%             ylabel('Log Beta Power')
%             xticks([1 2])
%             xticklabels({'Pre','Post'});
%             title([sessioninfo.trialnames{trial},'--',epocheventnames{et},'  (',num2str(numel(negdiff)),';',num2str(averagediff),')'])
%             ax=[ax gca];
%         end
%     end
%     sgtitle(laterality{lat})
%     legend
%     linkaxes(ax);
%     saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))
% end
% 
% 
% % Calculate beta power change (bar graph)
% reactivitydata=epochs.vrreactivity;
% fn=fieldnames(reactivitydata);
% epocheventnames={'Hold','Prep','Move'};
% laterality=({'stimside','contraside'});
% stats=true;
% 
% figure('Name',[figtitle,'--beta reactivity--bar'],'units','normalized','outerposition',[0 0 1 1]);
% for lat=1:numel(laterality)
%     for et=1:numel(epocheventtypes)
%         bardat=[];
%         semdat=[];
%         inputmat=[];
%         between_factors=[];
%         for trial=1:numel(fn)
%             tdat=reactivitydata.(fn{trial});
%             psddat=tdat.(epocheventtypes{et}).psd;
% 
%             sawdat=psddat.saw;
%             freqdat=psddat.freq;
% 
%             for rc=1:size(sawdat,1)
%                 betaidx=freqdat{rc,1}>=13 & freqdat{rc,1}<=30;
% 
%                 betareact.(epocheventtypes{et}).stimside(rc,1)=mean(log10(sawdat{rc,1}(betaidx,stim_cn)));
%                 betareact.(epocheventtypes{et}).stimside(rc,2)=mean(log10(sawdat{rc,2}(betaidx,stim_cn)));
% 
%                 betareact.(epocheventtypes{et}).contraside(rc,1)=mean(log10(sawdat{rc,1}(betaidx,contra_cn)));
%                 betareact.(epocheventtypes{et}).contraside(rc,2)=mean(log10(sawdat{rc,2}(betaidx,contra_cn)));
%             end
%             tempdat=betareact.(epocheventtypes{et}).(laterality{lat});
%             bardat=[bardat;mean(tempdat,1)];
%             semdat=[semdat;std(tempdat,1)./sqrt(size(tempdat,1))];
%             inputmat=[inputmat tempdat(:)];
%         end
%         between_factors=[ones(size(tempdat,1),1);ones(size(tempdat,1),1)*2];
%         subplot(numel(epocheventtypes),2,lat+(et-1)*2)
%         hold on
%         b=bar(bardat);
%         barpos=[b(1).XEndPoints' b(2).XEndPoints'];
%         errorbar(barpos,bardat,semdat,'Color',[0 0 0],'LineStyle','none')
%         ylabel('Log Beta Power')
%         xticklabels(trial_label);
%         title([epocheventnames{et},'--',laterality{lat}])
%         ylim([0 1.5])
%         ax=[ax gca];
%         if stats
%             % Run Mixed Anova for contra
%             [tbl,rm]=simple_mixed_anova(inputmat,between_factors,{'Trial'},{'PrevPost'});
% 
%             % Compare stim vs sham
%             Mrm1 = multcompare(rm,'PrevPost','By','Trial','ComparisonType','tukey-kramer');
% 
%             if any(Mrm1.pValue<=0.05)
%                 sigidx=double(unique(Mrm1.Trial(find(Mrm1.pValue<=0.05))));
%                 Ylimits=get(gca,'YLim');
%                 for i=1:numel(sigidx)
%                     text(sigidx(i),Ylimits(2)*0.8,'*','FontSize',20,'HorizontalAlignment','center')
%                 end
%             end
% 
%             % Compare time points
%             Mrm2 = multcompare(rm,'Trial','By','PrevPost','ComparisonType','bonferroni');
%             if any(Mrm2.pValue<=0.05)
%                 idx=find(Mrm2.pValue<=0.05);
%                 for i=1:numel(idx)
%                     t1=double(Mrm2.Trial_1(idx(i)));
%                     t2=double(Mrm2.Trial_2(idx(i)));
%                     pval=Mrm2.pValue(idx(i));
%                     if t1<t2
%                         if double(Mrm2.PrevPost(idx(i)))==1
%                             sigpos=barpos(:,1);
%                         else
%                             sigpos=barpos(:,2);
%                         end
%                         Ylimits=get(gca,'YLim');
%                         nYlimits=[Ylimits(1) Ylimits(2)+0.1*Ylimits(2)];
%                         set(gca,'YLim',nYlimits)
%                         l=line(gca,[sigpos(t1) sigpos(t2)],[1 1]*Ylimits(2));
%                         text(gca,mean([sigpos(t1) sigpos(t2)]),Ylimits(2),num2str(pval),'HorizontalAlignment','center');
%                         if double(Mrm2.PrevPost(idx(i)))==1
%                             set(l,'linewidth',2,'Color','b')
%                         else
%                             set(l,'linewidth',2,'Color',[0.8500 0.3250 0.0980])
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end
% legend({'Pre','Post'})
% saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))
% % linkaxes(ax);
% 
% % %% 
% % % PSD VR events Bar
% % figure('Name',['Beta Bar Graph-VR events==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% % subplot(1,2,1)
% % bar_dat_cn7=[];
% % for i=1:length(Epochcompare)
% %     bar_dat_cn7{i,1}=mean(epochs.rest.psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,Epochcompare(i,1)));
% %     for z=1:length(epocheventtypes)
% %         bar_dat_cn7{i,z+1}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,:),[1 3 2]),1);
% %     end
% % end
% % temp_data=bar_dat_cn7;
% % beta_bar=cell2mat(cellfun(@mean,bar_dat_cn7,'UniformOutput',false));
% % b1=bar(beta_bar);
% % hold on
% % err=err_bar(b1,temp_data,beta_bar);
% % stats=[];
% % for i=1:size(temp_data,1)
% %     stats{i}=sigtest(gc56a,temp_data(i,2:end),beta_bar(i,2:end),err.data(i,2:end),err.location(2:end,i));
% % end
% % hold on
% % title('Channel 7(C3)')
% % xlabel('Trials')
% % ylabel('Beta Power')
% % ylim([0 40])
% % n_nums=[];
% % for i=1:length(Epochcompare)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),temp_data(i,:))),'\newline', trial_label{Epochcompare(i,2)}];
% % end
% % set(gca,'XTickLabel',n_nums);
% % grid on
% % grid minor
% % legend('Rest','Hold','Cue','Move')
% % 
% % subplot(1,2,2)
% % bar_dat_cn18=[];
% % for i=1:length(Epochcompare)
% %     bar_dat_cn18{i,1}=mean(epochs.rest.psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,Epochcompare(i,1)));
% %     for z=1:length(epocheventtypes)
% %         bar_dat_cn18{i,z+1}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,:),[1 3 2]),1);
% %     end
% % end
% % temp_data=bar_dat_cn18;
% % beta_bar=cell2mat(cellfun(@mean,bar_dat_cn18,'UniformOutput',false));
% % b1=bar(beta_bar);
% % hold on
% % err=err_bar(b1,temp_data,beta_bar);
% % stats=[];
% % for i=2:size(temp_data,1)
% %     stats{i}=sigtest(gca,temp_data(i,2:end),beta_bar(i,2:end),err.data(i,2:end),err.location(2:end,i));
% % end
% % hold on
% % title('Channel 18(C4)')
% % xlabel('Trials')
% % ylabel('Beta Power')
% % ylim([0 40])
% % n_nums=[];
% % for i=1:length(Epochcompare)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),temp_data(i,:))),'\newline', trial_label{Epochcompare(i,2)}];
% % end
% % set(gca,'XTickLabel',n_nums);
% % grid on
% % grid minor
% % legend('Rest','Hold','Cue','Move')
% % saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))
% % 
% % %% Baseline Beta VR phases
% % figure('Name',['Beta Bar VR Phases==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% % subplot(1,2,1)
% % bar_dat_cn7=[];
% % for i=1:length(Epochcompare)
% %     bar_dat_cn7{i,1}=mean(epochs.rest.psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,Epochcompare(i,1)));
% %     for z=1:length(epocheventtypes)
% %         bar_dat_cn7{i,z+1}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,:),[1 3 2]),1);
% %     end
% % end
% % temp_data=bar_dat_cn7';
% % beta_bar=cell2mat(cellfun(@mean,temp_data,'UniformOutput',false));
% % b1=bar(beta_bar);
% % hold on
% % err=err_bar(b1,temp_data,beta_bar);
% % stats=[];
% % for i=2:size(temp_data,1)
% %     stats{i}=sigtest(gca,temp_data(i,:),beta_bar(i,:),err.data(i,:),err.location(:,i));
% % end
% % title('Channel 7(C3)')
% % xlabel('Phases')
% % ylabel('Beta Power')
% % x_tick={'Rest','Hold','Prep','Move'};
% % n_nums=[];
% % for i=1:numel(x_tick)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),temp_data(i,:))),'\newline', x_tick{i}];
% % end
% % set(gca,'XTickLabel',n_nums);
% % legend(trial_label{Epochcompare(:,2)})
% % grid on
% % grid minor
% % subplot(1,2,2)
% % bar_dat_cn18=[];
% % for i=1:length(Epochcompare)
% %     bar_dat_cn18{i,1}=mean(epochs.rest.psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,Epochcompare(i,1)));
% %     for z=1:length(epocheventtypes)
% %         bar_dat_cn18{i,z+1}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,:),[1 3 2]),1);
% %     end
% % end
% % temp_data=bar_dat_cn18';
% % beta_bar=cell2mat(cellfun(@mean,temp_data,'UniformOutput',false));
% % b1=bar(beta_bar);
% % hold on
% % err=err_bar(b1,temp_data,beta_bar);
% % stats=[];
% % for i=2:size(temp_data,1)
% %     stats{i}=sigtest(gca,temp_data(i,:),beta_bar(i,:),err.data(i,:),err.location(:,i));
% % end
% % title('Channel 18(C4)')
% % xlabel('Phases')
% % ylabel('Beta Power')
% % n_nums=[];
% % for i=1:numel(x_tick)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),temp_data(i,:))),'\newline', x_tick{i}];
% % end
% % set(gca,'XTickLabel',n_nums);
% % legend(trial_label{Epochcompare(:,2)})
% % grid on
% % grid minor
% % 
% % saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))
% % 
% % %% Beta Difference
% % figure('Name',['Beta Bar Graph Difference-VR events==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% % bar_dat_cn7=[];
% % for i=1:length(Epochcompare)
% %     for z=1:length(epocheventtypes)
% %         bar_dat_cn7{i,z}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,:),[1 3 2]),1);
% %     end
% % end
% % bar_dat_cn7_diff=[];
% % for i=1:size(bar_dat_cn7,1)
% %     bar_dat_cn7_diff{i,1}=diff([bar_dat_cn7{i,1}; bar_dat_cn7{i,2}],1,1);
% %     bar_dat_cn7_diff{i,2}=diff([bar_dat_cn7{i,2}; bar_dat_cn7{i,3}],1,1);
% % end
% % 
% % subplot(2,2,1)
% % tempdata=bar_dat_cn7_diff(:,1);
% % beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% % b1=bar(beta_bar_mean);
% % hold on
% % err=err_bar(b1,tempdata,beta_bar_mean);
% % sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% % title('Hold-Prep (Cn7)')
% % xlabel('Trials')
% % ylabel('Beta Power Difference')
% % n_nums=[];
% % for i=1:length(Epochcompare)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% % end
% % set(gca,'XTickLabel',n_nums);
% % grid on
% % grid minor
% % 
% % subplot(2,2,2)
% % tempdata=bar_dat_cn7_diff(:,2);
% % beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% % b1=bar(beta_bar_mean);
% % hold on
% % err=err_bar(b1,tempdata,beta_bar_mean);
% % sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% % title('Prep-Move(Cn7)')
% % xlabel('Trials')
% % ylabel('Beta Power Difference')
% % n_nums=[];
% % for i=1:length(Epochcompare)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% % end
% % set(gca,'XTickLabel',n_nums);
% % grid on
% % grid minor
% % 
% % subplot(2,2,3)
% % bar_dat_cn18=[];
% % for i=1:size(Epochcompare,1)
% %     for z=1:length(epocheventtypes)
% %         bar_dat_cn18{i,z}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,:),[1 3 2]),1);
% %     end
% % end
% % bar_dat_cn18_diff=[];
% % for i=1:size(bar_dat_cn18,1)
% %     bar_dat_cn18_diff{i,1}=diff([bar_dat_cn18{i,1}; bar_dat_cn18{i,2}],1,1);
% %     bar_dat_cn18_diff{i,2}=diff([bar_dat_cn18{i,2}; bar_dat_cn18{i,3}],1,1);
% % end
% % tempdata=bar_dat_cn18_diff(:,1);
% % beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% % b1=bar(beta_bar_mean);
% % hold on
% % err=err_bar(b1,tempdata,beta_bar_mean);
% % sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% % title('Hold-Prep (Cn18)')
% % xlabel('Trials')
% % ylabel('Beta Power Difference')
% % n_nums=[];
% % n_nums=[];
% % for i=1:length(Epochcompare)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% % end
% % set(gca,'XTickLabel',n_nums);
% % grid on
% % grid minor
% % 
% % subplot(2,2,4)
% % tempdata=bar_dat_cn18_diff(:,2);
% % beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% % b1=bar(beta_bar_mean);
% % hold on
% % err=err_bar(b1,tempdata,beta_bar_mean);
% % sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% % title('Prep-Move(Cn18)')
% % xlabel('Trials')
% % ylabel('Beta Power Difference')
% % n_nums=[];
% % for i=1:size(Epochcompare,2)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% % end
% % set(gca,'XTickLabel',n_nums);
% % grid on
% % grid minor
% % saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))
% % 
% % 
% % figure('Name',['Beta Bar Graph Percent Difference-VR events==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% % bar_dat_cn7=[];
% % for i=1:size(Epochcompare,1)
% %     for z=1:length(epocheventtypes)
% %         bar_dat_cn7{i,z}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),7,:),[1 3 2]),1);
% %     end
% % end
% % bar_dat_cn7_diff=[];
% % for i=1:size(bar_dat_cn7,1)
% %     bar_dat_cn7_diff{i,1}=diff([bar_dat_cn7{i,1}; bar_dat_cn7{i,2}],1,1)./bar_dat_cn7{i,1};
% %     bar_dat_cn7_diff{i,2}=diff([bar_dat_cn7{i,2}; bar_dat_cn7{i,3}],1,1)./bar_dat_cn7{i,2};
% % end
% % 
% % subplot(2,2,1)
% % tempdata=bar_dat_cn7_diff(:,1);
% % beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% % b1=bar(beta_bar_mean);
% % hold on
% % err=err_bar(b1,tempdata,beta_bar_mean);
% % sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% % title('Hold-Prep (Cn7)')
% % xlabel('Trials')
% % ylabel('Beta Power % Difference')
% % n_nums=[];
% % for i=1:size(Epochcompare,1)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% % end
% % set(gca,'XTickLabel',n_nums);
% % grid on
% % grid minor
% % 
% % subplot(2,2,2)
% % tempdata=bar_dat_cn7_diff(:,2);
% % beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% % b1=bar(beta_bar_mean);
% % hold on
% % err=err_bar(b1,tempdata,beta_bar_mean);
% % sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% % title('Prep-Move(Cn7)')
% % xlabel('Trials')
% % ylabel('Beta Power % Difference')
% % n_nums=[];
% % for i=1:length(Epochcompare)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% % end
% % set(gca,'XTickLabel',n_nums);
% % grid on
% % grid minor
% % 
% % subplot(2,2,3)
% % bar_dat_cn18=[];
% % for i=1:length(Epochcompare)
% %     for z=1:length(epocheventtypes)
% %         bar_dat_cn18{i,z}=mean(permute(epochs.vrevents.(['t',num2str(Epochcompare(i,2))]).(epocheventtypes{z}).psd.saw(freq_idx_beta(1):freq_idx_beta(2),18,:),[1 3 2]),1);
% %     end
% % end
% % bar_dat_cn18_diff=[];
% % for i=1:size(bar_dat_cn18,1)
% %     bar_dat_cn18_diff{i,1}=diff([bar_dat_cn18{i,1}; bar_dat_cn18{i,2}],1,1)./bar_dat_cn18{i,1};
% %     bar_dat_cn18_diff{i,2}=diff([bar_dat_cn18{i,2}; bar_dat_cn18{i,3}],1,1)./bar_dat_cn18{i,2};
% % end
% % tempdata=bar_dat_cn18_diff(:,1);
% % beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% % b1=bar(beta_bar_mean);
% % hold on
% % err=err_bar(b1,tempdata,beta_bar_mean);
% % sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% % title('Hold-Prep (Cn18)')
% % xlabel('Trials')
% % ylabel('Beta Power % Difference')
% % n_nums=[];
% % n_nums=[];
% % for i=1:length(Epochcompare)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% % end
% % set(gca,'XTickLabel',n_nums);
% % grid on
% % grid minor
% % 
% % subplot(2,2,4)
% % tempdata=bar_dat_cn18_diff(:,2);
% % beta_bar_mean=cell2mat(cellfun(@mean,tempdata,'UniformOutput',false));
% % b1=bar(beta_bar_mean);
% % hold on
% % err=err_bar(b1,tempdata,beta_bar_mean);
% % sigtest(gca,tempdata',beta_bar_mean,err.data,err.location);
% % title('Prep-Move(Cn18)')
% % xlabel('Trials')
% % ylabel('Beta Power % Difference')
% % n_nums=[];
% % for i=1:length(Epochcompare)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% % end
% % set(gca,'XTickLabel',n_nums);
% % grid on
% % grid minor
% % saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))
% % 
% % figure('Name',['Beta Reactivity ratio==',figtitle],'units','normalized','outerposition',[0 0 1 1])
% % switch sessioninfo.stimlat
% %     case 'R'
% %         stim_side=bar_dat_cn18_diff;
% %         nonstim_side=bar_dat_cn7_diff;
% %     case 'L'
% %         nonstim_side=bar_dat_cn18_diff;
% %         stim_side=bar_dat_cn7_diff;
% % end
% % subplot(1,2,1)
% % rr=cell(length(stim_side),1);
% % for i=1:length(rr)
% %     rr{i}=stim_side{i,1}./nonstim_side{i,1};
% % end
% % b1=bar(cellfun(@mean,rr));
% % hold on
% % err=err_bar(b1,rr,cellfun(@mean,rr));
% % sigtest(gca,rr',cellfun(@mean,rr),err.data,err.location);
% % xlabel('Trials')
% % ylabel('Beta Reactivity Ratio')
% % title('Hold to Prep Beta Reactivity Ratio')
% % n_nums=[];
% % for i=1:length(Epochcompare)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% % end
% % set(gca,'XTickLabel',n_nums,'XTickLabelRotation',30);
% % 
% % subplot(1,2,2)
% % rr=cell(length(stim_side),1);
% % for i=1:length(rr)
% %     rr{i}=stim_side{i,2}./nonstim_side{i,2};
% % end
% % b1=bar(cellfun(@mean,rr));
% % hold on
% % err=err_bar(b1,rr,cellfun(@mean,rr));
% % sigtest(gca,rr',cellfun(@mean,rr),err.data,err.location);
% % xlabel('Trials')
% % ylabel('Beta Reactivity Ratio')
% % title('Prep to Move Beta Reactivity Ratio')
% % n_nums=[];
% % for i=1:length(Epochcompare)
% %     n_nums{i}=[num2str(cellfun(@(x) numel(x),tempdata(i,1))),'\newline', trial_label{Epochcompare(i,2)}];
% % end
% % set(gca,'XTickLabel',n_nums,'XTickLabelRotation',30);
% % saveas(gcf,fullfile(vrepochfolder,[get(gcf,'Name'),'.jpg']))

%% Save variables
save(fullfile(eeganalysisfolder,'s3_dat'),'Epochcompare','epochs')
close all
end