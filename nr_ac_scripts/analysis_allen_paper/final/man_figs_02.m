sbjs_all=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36']

%this is to generate the lat variable
for i=1:21
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',...
        sbjs_all(i,:),'/analysis/S1-VR_preproc/pro00087153_00',sbjs_all(i,:),...
        '_S1-VRdata_preprocessed.mat'')'])
    if sessioninfo.stimlat=='L'
        eval(['lat(i)=7'])
    elseif sessioninfo.stimlat=='R'
        eval(['lat(i)=18'])
    end
    clear metric* movement* session* trialData*
end
%wow I ended up having to go all the way back to the CRFs and videos on
%this one but sbj 43 is labeled incorrectly, it should be left and it is
%labeled right so I will manually change here:
lat(5)=7;



trial={'pre{1,1}';'stim{1,1}';'stim{1,2}';'post{1,1}'}
trial_lbl={'pre';'estim';'lstim';'post'};

% %here I was just checking with the other plot to make sure the individual
% %eeg epochs matched which they do!
% plot([movementstart.post{1,1}(9)*fs movementstart.post{1,1}(9)*fs],[-20.2 20.2],'r')
% plot([movementstart.post{1,1}(9)*fs+2*fs movementstart.post{1,1}(9)*fs+2*fs],[-20.2 20.2],'g')
% plot([movementstart.post{1,1}(9)*fs-2*fs movementstart.post{1,1}(9)*fs-2*fs],[-20.2 20.2],'g')

for i=1:21
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_all(i,:),'/analysis/S2-metrics/pro00087153_00',sbjs_all(i,:),'_S2-Metrics.mat'')'])
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_all(i,:),'/analysis/S1-VR_preproc/pro00087153_00',sbjs_all(i,:),'_S1-VRdata_preprocessed.mat'')'])
    fs=trialData.eeg.header.samplingrate
    for j=1:4
        for k=1:12
            eval(['data_eeg_sbj',sbjs_all(i,:),'_c3_',trial_lbl{j},'(',num2str(k),',:)=trialData.eeg.data(movementstart.',trial{j},'(',num2str(k),')*fs-2*fs:movementstart.',trial{j},'(',num2str(k),')*fs+2*fs,7);'])
            eval(['data_eeg_sbj',sbjs_all(i,:),'_c4_',trial_lbl{j},'(',num2str(k),',:)=trialData.eeg.data(movementstart.',trial{j},'(',num2str(k),')*fs-2*fs:movementstart.',trial{j},'(',num2str(k),')*fs+2*fs,18);'])
        end
        eval(['mean_data_eeg_sbj',sbjs_all(i,:),'_c3_',trial_lbl{j},'=mean(data_eeg_sbj',sbjs_all(i,:),'_c3_',trial_lbl{j},');'])
        eval(['mean_data_eeg_sbj',sbjs_all(i,:),'_c4_',trial_lbl{j},'=mean(data_eeg_sbj',sbjs_all(i,:),'_c4_',trial_lbl{j},');'])
        eval(['se_data_eeg_sbj',sbjs_all(i,:),'_c3_',trial_lbl{j},'=std(data_eeg_sbj',sbjs_all(i,:),'_c3_',trial_lbl{j},')/sqrt(4);'])
        eval(['se_data_eeg_sbj',sbjs_all(i,:),'_c4_',trial_lbl{j},'=std(data_eeg_sbj',sbjs_all(i,:),'_c4_',trial_lbl{j},')/sqrt(4);'])
    end
    clear metric* movement* session* trialData*
    
    figure
    set(gcf,'Position',[749 172 667 790]) 
    spi_c3=[1 3 5 7];
    spi_c4=[2 4 6 8];
    for j=1:4
        subplot(5,2,spi_c3(j))
        %quality check eval(['plot(data_eeg_sbj',sbjs_all(i,:),'_c3_',trial_lbl{j},'(9,:)'')'])
        eval(['plot(data_eeg_sbj',sbjs_all(i,:),'_c3_',trial_lbl{j},''')'])
        if j==1 & lat(i)==7
            title(['sbj',sbjs_all(i,:),' ',trial_lbl{j},' c3*'])
        elseif j==1 & lat(i)==18
                        title(['sbj',sbjs_all(i,:),' ',trial_lbl{j},' c3'])
        else
            title(trial_lbl{j})
        end
    end
    for j=1:4
        subplot(5,2,spi_c4(j))
        %quality check eval(['plot(data_eeg_sbj',sbjs_all(i,:),'_c4_',trial_lbl{j},'(9,:)'')'])
        eval(['plot(data_eeg_sbj',sbjs_all(i,:),'_c4_',trial_lbl{j},''')'])
        if j==1 & lat(i)==18
            title(['sbj',sbjs_all(i,:),' ',trial_lbl{j},' c4*'])
        elseif j==1 & lat(i)==7
            title(['sbj',sbjs_all(i,:),' ',trial_lbl{j},' c4'])
        else
            title(trial_lbl{j})
        end
    end
    subplot(5,2,9); hold on
    for k=1:4
        eval(['plot(mean_data_eeg_sbj',sbjs_all(i,:),'_c3_',trial_lbl{k},''')'])
    end
    legend('pre','early','late','post')
    subplot(5,2,10); hold on
    for k=1:4
        eval(['plot(mean_data_eeg_sbj',sbjs_all(i,:),'_c4_',trial_lbl{k},''')'])
    end
%indicate contralateral
end
%ok what's needed here is:
0) make sure to fix the lat variable - can also look in session info
1) figure out what's going on with 42 and 43
2) the raw signal needs to be filtered
3) may also need to be z-scored to get everything in the same sampamplitude range
4) I would maybe plot the movement start times against the raw data and compare the individuals erp's you generate
5) read a paper on these to see how these are done
6) put shading around means curves
7) make sure to remove bad trials

%ok so let's try to find the code that plots the movement times on the raw
%data - I know I already have this somewhere

%figure
        
        
        
        % if i==1
    %     title('03 pre reach 1')
    % else
    %     title(['reach ', num2str(i)])
    % end
    %end

    
    %Fig 1
%this is the stim
sbj_no='22'
fldr_nm=['pro00087153_00',sbj_no];
file_nm=['pro00087153_00',sbj_no,'_S1-VRdata_preprocessed.mat'];
load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/',fldr_nm,...
    '/analysis/S1-VR_preproc/',file_nm])
figure; hold on
set(gcf,'Position',[1312 540 597 419])
plot(trialData.eeg.data(2e6:end,7))
min_ch7=min(trialData.eeg.data(:,7));
max_ch18=max(trialData.eeg.data(:,18));
min_ch18=min(trialData.eeg.data(:,18));
plot(trialData.eeg.data(2e6:end,18)+min_ch7-max_ch18)
plot(trialData.eeg.sync(2e6:end,1)*1e4+min_ch7-max_ch18+min_ch18)
max_ch42=max(trialData.eeg.data(:,42)*-1);
plot(trialData.eeg.data(2e6:end,43)*-5+min_ch7-max_ch18+min_ch18-max_ch42)
title([fldr_nm,' gen 03'])
legend('C3','C4','VR','current')

%in adobe illustrator, I would point out the large deflections in the EEG,
% where machine is turned off (arrow below pointing upward), I would point
% 1 min period of ramping up then down, 20 min period of maching being on
% this should go to the left
% then can zoom in on before and after period

figure; hold on
set(gcf,'Position',[1312 540 597 419])
plot(trialData.eeg.data(3.5e6:4.5e6,7))
%set(gca,'ylim',[-2e3 2e3])
%this should be the inset