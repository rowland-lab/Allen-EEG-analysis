sbj_no='04'
fldr_nm=['pro00087153_00',sbj_no];
file_nm=['pro00087153_00',sbj_no,'_S1-VRdata_preprocessed.mat'];
load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/',fldr_nm,...
    '/analysis/S1-VR_preproc/',file_nm])
fs=trialData.eeg.header.samplingrate

%%%%%%%%%%%%%%%%%% plotting outlier epochs %%%%%%%%%%%%%%%%%%
f1=figure('Position',[5 87 1131 852]); 
%title(sbjname)
file_nm=['pro00087153_00',sbj_no,'_S2-Metrics.mat'];
load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/',fldr_nm,...
    '/analysis/S2-metrics/',file_nm],'movementstart')
hold on
plot((trialData.eeg.data(:,7)-mean(trialData.eeg.data(:,7)))/std(trialData.eeg.data(:,7)))
%plot((trialData.eeg.data(:,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18))-20)
plot((trialData.eeg.data(:,sessioninfo.vrchan)-mean(trialData.eeg.data(:,sessioninfo.vrchan)))/std(trialData.eeg.data(:,sessioninfo.vrchan))-60)
plot(((trialData.eeg.data(:,sessioninfo.tdcschan)-mean(trialData.eeg.data(:,sessioninfo.tdcschan)))/std(trialData.eeg.data(:,sessioninfo.tdcschan))*-1)-80,'LineWidth',2)
%UNCOMMENT- THIS IS YOUR POSITION DATA!!!!%
% for i=1:size(trialData.vr,2)
%     plot(trialData.vr(i).tracker.time*fs,trialData.vr(i).tracker.p.right(:,1)*50,'r','LineWidth',2)
% end


plot(movementstart.pre{1,1}*fs,linspace(0,0,12),'g.','MarkerSize',15)
plot(movementstart.stim{1,1}*fs,linspace(0,0,12),'g.','MarkerSize',15)
plot(movementstart.stim{1,2}*fs,linspace(0,0,12),'g.','MarkerSize',15)
plot(movementstart.post{1,1}*fs,linspace(0,0,12),'g.','MarkerSize',15)

Session_times=sessioninfo.sessionperiod;
xlim([Session_times{1} Session_times{2}]);
yplotlim=get(gca,'ylim');






% % Add rest epochs
% for i=1:length(epochs.rest.val)
%     h1=plot([epochs.rest.val(i,1) epochs.rest.val(i,1)],yplotlim,'-g','LineWidth',2);
%     plot([epochs.rest.val(i,2) epochs.rest.val(i,2)],yplotlim,'-r','LineWidth',2);
%     text(mean([epochs.rest.val(i,1) epochs.rest.val(i,2)]),yplotlim(2)*0.9,["Rest Epoch",num2str(i)],'HorizontalAlign','Center')
% end

file_nm=['s3_dat.mat'];
load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/',fldr_nm,...
    '/analysis/S3-EEGanalysis/',file_nm])

%Add VR whole epochs
for i=1:length(epochs.vrwhole.val)
    h2=plot([epochs.vrwhole.val(i,1) epochs.vrwhole.val(i,1)],yplotlim,'-.g','LineWidth',1);
    plot([epochs.vrwhole.val(i,2) epochs.vrwhole.val(i,2)],yplotlim,'-.r','LineWidth',1);
    text(mean([epochs.vrwhole.val(i,1) epochs.vrwhole.val(i,2)]),yplotlim(2)*0.9,["VR Epoch",num2str(i)],'HorizontalAlign','Center')
end

% Epoch VR events
epocheventtypes={'atStartPosition','cueEvent','targetUp'};
epocheventlabels={'Hold','Prep','Move'};

% epocheventtypes={'targetUp'};
% epocheventlabels={'Move'};

length(fieldnames(trialData.vr))
   
% Add VR event epochs - adds lines
for i=1:length(fieldnames(epochs.epochsWhole))
    for z=1:length(epocheventtypes)
        temp_val=eval(['epochs.epochsWhole.t',num2str(i),'.',epocheventtypes{z},'.val']);
        for q=1:length(temp_val)
            h3=plot([temp_val(q) temp_val(q)],yplotlim,'-b','LineWidth',0.5);
        end
    end
end

%plot(trialData.vr(1).tracker.p.right(1700:2100,1))

clearvars eventtimelist
fs=trialData.eeg.header.samplingrate;
%adds text descriptors
for i=1:length(trialData.vr)
    fieldnamesevents=fieldnames(trialData.vr(i).events);
    eventtimelist=0;
    for t=1:length(fieldnamesevents)-1
        eval(['eventtimes=trialData.vr(i).events.',fieldnamesevents{t+1},'.time;'])
        for q=1:length(eventtimes)
            if any(eventtimelist==eventtimes(q))
                text(eventtimes(q)*fs,0,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q),'(',num2str(i),')'],'FontSize',11,'Rotation',-90,'FontWeight','bold')
                text(eventtimes(q)*fs,-20,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q),'(',num2str(i),')'],'FontSize',11,'Rotation',-90,'FontWeight','bold')
            else
                text(eventtimes(q)*fs,0,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q),'(',num2str(i),')'],'FontSize',11,'Rotation',90,'FontWeight','bold')
                text(eventtimes(q)*fs,-20,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q),'(',num2str(i),')'],'FontSize',11,'Rotation',90,'FontWeight','bold')
            end
            eventtimelist=[eventtimelist eventtimes(q)];
        end
    end   
end
% figure
% %plot(trialData.vr(1).tracker.time,trialData.vr(1).tracker.p.left,'r','LineWidth',2)
% plot(trialData.vr(1).tracker.p.left(:,1),'r','LineWidth',2)

%legend('C3','C4','EKG','VR','tDCS')

%for this next part, there are movement start and end times somewhere. Find
%them!!
