function nr_eeg_anal_sum_01_data_vis_01(sbj_no)

%maybe you can plot gen_03 beside gen_02!

%sbj_no='03'
% fldr_nm=['pro00087153_00',sbj_no];
% file_nm=['pro00087153_00',sbj_no,'_S1-VRdata_preprocessed.mat'];
% 
% load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_02/data/',fldr_nm,...
%     '/analysis/S1-VR_preproc/',file_nm])
% figure; hold on
% set(gcf,'Position',[671 529 577 433])
% plot(trialData.eeg.data(:,7))
% hold on
% min_ch7=min(trialData.eeg.data(:,7));
% max_ch18=max(trialData.eeg.data(:,18));
% min_ch18=min(trialData.eeg.data(:,18));
% plot(trialData.eeg.data(:,18)+min_ch7-max_ch18)
% plot(trialData.eeg.sync(:,1)*1000+min_ch7-max_ch18+min_ch18)
% max_ch42=max(trialData.eeg.data(:,42)*-1);
% plot(trialData.eeg.data(:,42)*-1+min_ch7-max_ch18+min_ch18-max_ch42)
% title([fldr_nm,' gen 02'])
% legend('C3','C4','VR','current')
% 
% clear m* sessioninfo trialData

%sbj_no='03'
fldr_nm=['pro00087153_00',sbj_no];
file_nm=['pro00087153_00',sbj_no,'_S1-VRdata_preprocessed.mat'];
load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/',fldr_nm,...
    '/analysis/S1-VR_preproc/',file_nm])
figure; hold on
set(gcf,'Position',[1312 540 597 419])
plot(trialData.eeg.data(:,7))
min_ch7=min(trialData.eeg.data(:,7));
max_ch18=max(trialData.eeg.data(:,18));
min_ch18=min(trialData.eeg.data(:,18));
plot(trialData.eeg.data(:,18)+min_ch7-max_ch18)
plot(trialData.eeg.sync(:,1)*1000+min_ch7-max_ch18+min_ch18)
max_ch42=max(trialData.eeg.data(:,42)*-1);
plot(trialData.eeg.data(:,42)*-1+min_ch7-max_ch18+min_ch18-max_ch42)
title([fldr_nm,' gen 03'])
legend('C3','C4','VR','current')

open(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/',fldr_nm,...
     '/analysis/S1-VR_preproc/EEG_tDCS_VR Plot.fig'])
 set(gcf,'Position',[0.5216 0.0454 0.3589 0.7806])