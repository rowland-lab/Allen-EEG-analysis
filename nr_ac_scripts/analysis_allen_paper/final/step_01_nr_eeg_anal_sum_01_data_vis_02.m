function step_01_nr_eeg_anal_sum_01_data_vis_02(sbj_no)

%sbj_no='03'
fldr_nm=['pro00087153_00',sbj_no];
file_nm=['pro00087153_00',sbj_no,'_S1-VRdata_preprocessed.mat'];
load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/',fldr_nm,...
    '/analysis/S1-VR_preproc/',file_nm])

trialData.eeg.data=trialData.eeg.data(:,1:22);

% 60 H notch filter
[n1_b, n1_a]=butter(3,2*[57 63]/trialData.eeg.header.samplingrate,'stop');%60 Hz
trialData.eeg.data=filtfilt(n1_b,n1_a,trialData.eeg.data);

% %0.5 Hz high pass filter
X=highpass(trialData.eeg.data,0.5,trialData.eeg.header.samplingrate);
trialData.eeg.data=X;

%Calculate car and check against original signals
mean_sig=mean(trialData.eeg.data(:,[1:22]),2);
for i=1:22
    %figure; set(gcf,'Position',[1828 424 583 437])
    figure; set(gcf,'Position',[2416 419 583 437])
    hold on
    plot(trialData.eeg.data(:,i))
    %plot(mean_sig)
    plot(trialData.eeg.data(:,i)-mean_sig)
    title([fldr_nm,' channel ',num2str(i)])
    legend('orig','car')
end



figure
set(gcf,'Position',[1647 116 1117 716])
subplot(1,2,1); hold on
for i=1:22
    if i==1
        plot(trialData.eeg.data(:,i))
    else
        plot(trialData.eeg.data(:,i)-i*5e4)
    end
end
%legend
title([fldr_nm,' gen 03'])

subplot(1,2,2); hold on
for i=1:22
    if i==1
        plot(trialData.eeg.data(:,i)-mean_sig)
    else
        plot((trialData.eeg.data(:,i)-mean_sig)-i*5e4)
    end
end
%legend



% 
% 
% 
% min_ch7=min(trialData.eeg.data(:,7));
% max_ch18=max(trialData.eeg.data(:,18));
% min_ch18=min(trialData.eeg.data(:,18));
% plot(trialData.eeg.data(:,18)+min_ch7-max_ch18)
% plot(trialData.eeg.sync(:,1)*1000+min_ch7-max_ch18+min_ch18)
% max_ch42=max(trialData.eeg.data(:,42)*-1);
% plot(trialData.eeg.data(:,42)*-1+min_ch7-max_ch18+min_ch18-max_ch42)
% 
% legend('C3','C4','VR','current')
% 
% open(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/',fldr_nm,...
%      '/analysis/S1-VR_preproc/EEG_tDCS_VR Plot.fig'])
%  set(gcf,'Position',[0.5216 0.0454 0.3589 0.7806])